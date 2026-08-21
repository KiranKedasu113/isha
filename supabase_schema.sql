-- ============================================================
-- ISHA CAFE — SUPABASE POSTGRESQL DATABASE SCHEMA
-- ============================================================
-- Instructions:
-- 1. Log in to your Supabase Dashboard (https://supabase.com)
-- 2. Select your Project -> Click "SQL Editor" on the left menu
-- 3. Click "New Query", paste this entire SQL script, and click "Run"
-- ============================================================

-- 1. CREATE ORDERS TABLE
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token INT NOT NULL,
    table_no TEXT NOT NULL DEFAULT '1',
    items JSONB NOT NULL DEFAULT '{}'::jsonb,
    total_amount NUMERIC(10,2) DEFAULT 0.00,
    status TEXT NOT NULL DEFAULT 'Pending', -- 'Pending', 'Printed', 'Completed'
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. CREATE GLOBAL TOKEN COUNTER TABLE
CREATE TABLE IF NOT EXISTS public.token_counter (
    id INT PRIMARY KEY DEFAULT 1,
    current_token INT NOT NULL DEFAULT 100,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Insert initial token counter record starting at 100
INSERT INTO public.token_counter (id, current_token)
VALUES (1, 100)
ON CONFLICT (id) DO NOTHING;

-- 3. ATOMIC TOKEN INCREMENT FUNCTION
CREATE OR REPLACE FUNCTION public.get_next_token()
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    next_tok INT;
BEGIN
    UPDATE public.token_counter
    SET current_token = current_token + 1,
        updated_at = NOW()
    WHERE id = 1
    RETURNING current_token INTO next_tok;
    
    RETURN next_tok;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_next_token() TO anon, authenticated, service_role;

-- 4. ENABLE ROW LEVEL SECURITY (RLS) POLICIES FOR PUBLIC CAFÉ ACCESS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.token_counter ENABLE ROW LEVEL SECURITY;

-- Clean up existing policies if re-running script
DROP POLICY IF EXISTS "Allow public read access to orders" ON public.orders;
DROP POLICY IF EXISTS "Allow public insert access to orders" ON public.orders;
DROP POLICY IF EXISTS "Allow public update access to orders" ON public.orders;
DROP POLICY IF EXISTS "Allow public delete access to orders" ON public.orders;
DROP POLICY IF EXISTS "Allow public read token counter" ON public.token_counter;
DROP POLICY IF EXISTS "Allow public update token counter" ON public.token_counter;

-- Allow public SELECT, INSERT, UPDATE, DELETE on orders table
CREATE POLICY "Allow public read access to orders" 
ON public.orders FOR SELECT USING (true);

CREATE POLICY "Allow public insert access to orders" 
ON public.orders FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public update access to orders" 
ON public.orders FOR UPDATE USING (true);

CREATE POLICY "Allow public delete access to orders" 
ON public.orders FOR DELETE USING (true);

-- Allow public read & update on token counter
CREATE POLICY "Allow public read token counter" 
ON public.token_counter FOR SELECT USING (true);

CREATE POLICY "Allow public update token counter" 
ON public.token_counter FOR UPDATE USING (true);

-- 5. ENABLE REALTIME WEBSOCKET REPLICATION FOR INSTANT POS SYNC
DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;
