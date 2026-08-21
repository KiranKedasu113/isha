/* ============================================================
-- ISHA CAFE — CENTRAL CONFIGURATION (SUPABASE POSTGRESQL & QZ TRAY)
-- ============================================================ */
window.ISHA_CAFE_CONFIG = {
  SUPABASE_URL: "https://qftftnrqtyhvnwdhstrz.supabase.co",
  SUPABASE_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmdGZ0bnJxdHlodm53ZGhzdHJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcyOTYzMTcsImV4cCI6MjEwMjg3MjMxN30.MpzpPVgmrbB8JmEI1jat216HJh9XXT426RNxialyoc4"
};

function getSupabaseUrl(){
  const local = localStorage.getItem('isha_cafe_supabase_url');
  if(local && local.trim()) return local.trim();
  return window.ISHA_CAFE_CONFIG.SUPABASE_URL;
}

function getSupabaseKey(){
  const local = localStorage.getItem('isha_cafe_supabase_key');
  if(local && local.trim()) return local.trim();
  return window.ISHA_CAFE_CONFIG.SUPABASE_KEY;
}

// Local QZ Tray Printer Preferences (stored strictly in browser localStorage)
function getSavedBillPrinter(){
  return localStorage.getItem('isha_cafe_bill_printer') || '';
}

function setSavedBillPrinter(name){
  localStorage.setItem('isha_cafe_bill_printer', name);
}

function getSavedKotPrinter(){
  return localStorage.getItem('isha_cafe_kot_printer') || '';
}

function setSavedKotPrinter(name){
  localStorage.setItem('isha_cafe_kot_printer', name);
}
