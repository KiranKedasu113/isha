/* ============================================================
-- ISHA CAFE — CENTRAL CONFIGURATION (SUPABASE POSTGRESQL)
-- ============================================================
-- Paste your Supabase credentials here so customer mobile phones
-- can push orders directly into your PostgreSQL database.
-- ============================================================ */
window.ISHA_CAFE_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_KEY: ""
};

function getSupabaseUrl(){
  const local = localStorage.getItem('isha_cafe_supabase_url');
  if(local && local.trim()) return local.trim();
  if(window.ISHA_CAFE_CONFIG && window.ISHA_CAFE_CONFIG.SUPABASE_URL && window.ISHA_CAFE_CONFIG.SUPABASE_URL.startsWith('http')) {
    return window.ISHA_CAFE_CONFIG.SUPABASE_URL.trim();
  }
  return '';
}

function getSupabaseKey(){
  const local = localStorage.getItem('isha_cafe_supabase_key');
  if(local && local.trim()) return local.trim();
  if(window.ISHA_CAFE_CONFIG && window.ISHA_CAFE_CONFIG.SUPABASE_KEY && window.ISHA_CAFE_CONFIG.SUPABASE_KEY.length > 20) {
    return window.ISHA_CAFE_CONFIG.SUPABASE_KEY.trim();
  }
  return '';
}
