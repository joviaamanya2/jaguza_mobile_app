@php
    // Get data from controller or use defaults
    $stats = $stats ?? [
        'total_users' => 0,
        'total_animals' => 0,
        'total_farms' => 0,
        'open_reports' => 0,
        'total_doctors' => 0,
        'total_videos' => 0,
        'active_ads' => 0,
        'total_gestations' => 0,
    ];
    
    $recentReports = $recentReports ?? [];
    $livestockByType = $livestockByType ?? [];
    $recentVideos = $recentVideos ?? [];
    $activeAds = $activeAds ?? [];
    $weatherUpdates = $weatherUpdates ?? [];
    $decisionSupport = $decisionSupport ?? [];
    $dueGestations = $dueGestations ?? [];
    $users = $users ?? [];
    $doctors = $doctors ?? [];
    $diseases = $diseases ?? [];
    $farms = $farms ?? [];
    $animals = $animals ?? [];
    $vaccinations = $vaccinations ?? [];
    $notifications = $notifications ?? [];
    $marketplaceListings = $marketplaceListings ?? [];
    $weatherAdvisories = $weatherAdvisories ?? [];
    $settings = $settings ?? [];
    
    $months = $months ?? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
    $sicknessData = $sicknessData ?? [0,0,0,0,0,0,0];
    $userData = $userData ?? [0,0,0,0,0,0,0];
    $marketData = $marketData ?? [0,0,0,0,0,0,0];
    $livestockLabels = array_keys($livestockByType);
    $livestockValues = array_values($livestockByType);
    
    $userGrowthPercent = $userGrowthPercent ?? 0;
    $sicknessGrowthPercent = $sicknessGrowthPercent ?? 0;
    $farmGrowthPercent = $farmGrowthPercent ?? 0;
    $livestockGrowthPercent = $livestockGrowthPercent ?? 0;
    $newDoctors = $newDoctors ?? 0;
    $newVideosThisWeek = $newVideosThisWeek ?? 0;
    $expiredAds = $expiredAds ?? 0;
    $dueGestationsCount = $dueGestationsCount ?? 0;
    $dueGestationsThisMonth = $dueGestationsThisMonth ?? 0;
    
    $user = auth()->user();
    
    // ============================================
    // FIXED: Properly defined helper functions
    // ============================================
    
    function getInitials($name) {
        if (empty($name)) {
            return 'NA';
        }
        $words = explode(' ', $name);
        $initials = '';
        foreach ($words as $word) {
            if (!empty($word)) {
                $initials .= strtoupper(substr($word, 0, 1));
            }
        }
        return substr($initials, 0, 2);
    }
    
    function getStatusBadge($status) {
        return match($status) {
            'open', 'critical' => 'badge-red',
            'treating' => 'badge-orange',
            'resolved' => 'badge-green',
            'referred' => 'badge-blue',
            default => 'badge-purple',
        };
    }
    
    function getStatusDisplay($status) {
        return match($status) {
            'open' => 'Open',
            'treating' => 'Treating',
            'resolved' => 'Resolved',
            'critical' => 'Critical',
            'referred' => 'Referred',
            default => ucfirst($status),
        };
    }
@endphp

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Jaguza Admin Dashboard – Livestock Management</title>
  <meta name="csrf-token" content="{{ csrf_token() }}">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    /* ... (your existing styles remain the same) ... */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --green-900: #0a2e14; 
      --green-800: #133b24; 
      --green-700: #1b5e20;
      --green-600: #2e7d32; 
      --green-500: #388e3c; 
      --green-400: #43a047;
      --green-300: #66bb6a; 
      --green-200: #a5d6a7; 
      --green-100: #e8f5e9;
      --accent: #2e7d32; 
      --gold: #f5c518; 
      --red: #dc3545;
      --blue: #0d6efd; 
      --orange: #fd7e14;
      --sidebar-w: 260px; 
      --sidebar-collapsed: 68px;
      --topbar-h: 64px; 
      --radius: 12px;
      --shadow: 0 2px 12px rgba(0,0,0,.08);
      --transition: .25s cubic-bezier(.4,0,.2,1);
    }
    
    html, body { height: 100%; margin: 0; padding: 0; }
    body { 
      font-family:'Inter',sans-serif; 
      background:#f0f2f5; 
      color:#1a1a2e; 
      min-height:100vh; 
      display:flex; 
      overflow:hidden;
    }

    #sidebar { 
      width:var(--sidebar-w); 
      background:#ffffff; 
      border-right:1px solid #e8ecf1; 
      display:flex; 
      flex-direction:column; 
      transition:width var(--transition); 
      overflow:hidden; 
      position:fixed; 
      top:0; 
      left:0; 
      bottom:0; 
      z-index:100; 
      box-shadow:2px 0 12px rgba(0,0,0,.06); 
    }
    #sidebar.collapsed { width:var(--sidebar-collapsed); }
    
    .sidebar-logo { 
      display:flex; 
      align-items:center; 
      gap:12px; 
      padding:16px 20px; 
      background:linear-gradient(135deg, var(--green-700), var(--green-600));
      border-bottom:1px solid rgba(255,255,255,.1); 
      min-height:var(--topbar-h); 
      flex-shrink:0; 
    }
    .logo-icon { 
      width:40px; 
      height:40px; 
      background:rgba(255,255,255,.2); 
      border-radius:10px; 
      display:flex; 
      align-items:center; 
      justify-content:center; 
      flex-shrink:0; 
    }
    .logo-icon i { color:#fff; font-size:20px; }
    .logo-text { overflow:hidden; white-space:nowrap; }
    .logo-text h1 { font-size:18px; font-weight:700; color:#fff; letter-spacing:-.5px; }
    .logo-text span { font-size:11px; color:rgba(255,255,255,.7); font-weight:400; }
    
    .sidebar-scroll { 
      flex:1; 
      overflow-y:auto; 
      overflow-x:hidden; 
      padding:8px 0 20px; 
      min-height:0;
      background:#ffffff;
    }
    .sidebar-scroll::-webkit-scrollbar { width:4px; }
    .sidebar-scroll::-webkit-scrollbar-thumb { background:#d0d7de; border-radius:2px; }
    
    .nav-section-label { 
      font-size:10px; 
      font-weight:600; 
      text-transform:uppercase; 
      letter-spacing:0.8px; 
      color:#8c9aab; 
      padding:16px 20px 6px; 
      white-space:nowrap; 
      overflow:hidden; 
    }
    #sidebar.collapsed .nav-section-label { opacity:0; height:0; padding:0; }
    
    .nav-item { 
      display:flex; 
      align-items:center; 
      gap:12px; 
      padding:10px 16px; 
      margin:2px 10px; 
      border-radius:8px; 
      cursor:pointer; 
      transition:all var(--transition); 
      text-decoration:none; 
      color:#5a6a7a; 
      white-space:nowrap; 
      overflow:hidden; 
      position:relative; 
    }
    .nav-item:hover { background:#e8f5e9; color:#1b5e20; transform:translateX(2px); }
    .nav-item.active { background:#e8f5e9; color:#1b5e20; font-weight:500; }
    .nav-item .nav-icon { 
      width:34px; height:34px; display:flex; align-items:center; justify-content:center; 
      border-radius:8px; background:#f0f2f5; flex-shrink:0; font-size:14px; 
      transition:all var(--transition); color:#5a6a7a;
    }
    .nav-item:hover .nav-icon, .nav-item.active .nav-icon { background:#c8e6c9; color:#1b5e20; }
    .nav-item .nav-label { font-size:13px; font-weight:500; flex:1; }
    .nav-item .nav-badge { 
      background:#dc3545; color:#fff; font-size:10px; font-weight:600; 
      border-radius:10px; padding:1px 8px; flex-shrink:0; 
    }
    #sidebar.collapsed .nav-label, #sidebar.collapsed .nav-badge { display:none; }
    
    .sidebar-footer { padding:12px 16px; border-top:1px solid #e8ecf1; flex-shrink:0; background:#ffffff; }
    .sidebar-user { 
      display:flex; align-items:center; gap:10px; padding:8px 12px; 
      border-radius:8px; cursor:pointer; transition:background var(--transition); 
    }
    .sidebar-user:hover { background:#f0f2f5; }
    .user-avatar { 
      width:36px; height:36px; border-radius:50%; 
      background:linear-gradient(135deg, var(--green-500), var(--green-700)); 
      display:flex; align-items:center; justify-content:center; 
      color:#fff; font-size:14px; font-weight:600; flex-shrink:0; 
    }
    .user-info { overflow:hidden; }
    .user-info p { font-size:13px; font-weight:600; color:#1a1a2e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .user-info span { font-size:11px; color:#8c9aab; }
    #sidebar.collapsed .user-info { display:none; }

    #topbar { 
      position:fixed; top:0; left:var(--sidebar-w); right:0; height:var(--topbar-h); 
      background:#ffffff; border-bottom:1px solid #e8ecf1; 
      display:flex; align-items:center; justify-content:space-between; 
      padding:0 24px; z-index:90; transition:left var(--transition); 
    }
    #topbar.shifted { left:var(--sidebar-collapsed); }
    .topbar-left { display:flex; align-items:center; gap:16px; }
    #toggle-btn { 
      width:36px; height:36px; background:#f0f2f5; border:1px solid #e8ecf1; 
      border-radius:8px; color:#1a1a2e; cursor:pointer; display:flex; 
      align-items:center; justify-content:center; font-size:16px; 
      transition:all var(--transition); 
    }
    #toggle-btn:hover { background:#e8f5e9; border-color:#a5d6a7; color:#1b5e20; }
    #page-title { font-size:18px; font-weight:600; color:#1a1a2e; }
    
    .topbar-search { 
      display:flex; align-items:center; background:#f0f2f5; border:1px solid #e8ecf1; 
      border-radius:8px; padding:0 14px; gap:8px; height:38px; min-width:220px; 
      transition:all var(--transition);
    }
    .topbar-search:focus-within { border-color:#66bb6a; box-shadow:0 0 0 3px rgba(46,125,50,.1); }
    .topbar-search i { color:#8c9aab; font-size:14px; }
    .topbar-search input { background:transparent; border:none; outline:none; color:#1a1a2e; font-size:13px; width:100%; }
    .topbar-search input::placeholder { color:#b0bec5; }
    
    .topbar-right { display:flex; align-items:center; gap:8px; }
    .topbar-action-btn { 
      width:36px; height:36px; border-radius:8px; background:transparent; 
      border:1px solid #e8ecf1; color:#5a6a7a; cursor:pointer; display:flex; 
      align-items:center; justify-content:center; font-size:15px; position:relative; 
      transition:all var(--transition); 
    }
    .topbar-action-btn:hover { background:#e8f5e9; border-color:#a5d6a7; color:#1b5e20; }
    .topbar-badge { 
      position:absolute; top:-4px; right:-4px; width:18px; height:18px; 
      background:#dc3545; border-radius:50%; font-size:9px; color:#fff; 
      font-weight:600; display:flex; align-items:center; justify-content:center; 
    }

    #main-wrap { 
      margin-left:var(--sidebar-w); margin-top:var(--topbar-h); flex:1; 
      height:calc(100vh - var(--topbar-h)); overflow-y:auto; overflow-x:hidden; 
      transition:margin-left var(--transition); position:relative; background:#f0f2f5;
    }
    #main-wrap.shifted { margin-left:var(--sidebar-collapsed); }
    .page { display:none; padding:28px; animation:fadeIn .3s ease; min-height:100%; }
    .page.active { display:block; }
    @keyframes fadeIn { from{opacity:0;transform:translateY(10px)} to{opacity:1;transform:translateY(0)} }

    #main-wrap::-webkit-scrollbar { width:8px; }
    #main-wrap::-webkit-scrollbar-track { background:#f0f2f5; }
    #main-wrap::-webkit-scrollbar-thumb { background:#c8d0d8; border-radius:4px; }
    #main-wrap::-webkit-scrollbar-thumb:hover { background:#a8b8c8; }

    .stats-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:18px; margin-bottom:28px; }
    .stat-card { 
      background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); 
      padding:20px 22px; display:flex; align-items:center; gap:16px; 
      box-shadow:var(--shadow); transition:all .2s; 
    }
    .stat-card:hover { transform:translateY(-2px); box-shadow:0 4px 20px rgba(0,0,0,.08); border-color:#a5d6a7; }
    .stat-icon { width:50px; height:50px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; flex-shrink:0; }
    .stat-body h3 { font-size:24px; font-weight:700; color:#1a1a2e; }
    .stat-body p { font-size:12.5px; color:#6a7a8a; margin-top:2px; }
    .stat-trend { font-size:11px; font-weight:600; margin-top:4px; }
    .trend-up { color:#2e7d32; } .trend-down { color:#dc3545; }

    .section-heading { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
    .section-heading h2 { font-size:16px; font-weight:600; color:#1a1a2e; }
    .btn { padding:8px 20px; border-radius:8px; font-size:13px; font-weight:500; cursor:pointer; border:none; transition:all .2s; }
    .btn:hover { opacity:.9; transform:translateY(-1px); box-shadow:0 4px 12px rgba(46,125,50,.2); }
    .btn-primary { background:linear-gradient(135deg, var(--green-600), var(--green-700)); color:#fff; }
    .btn-outline { background:transparent; border:1px solid #c8d0d8; color:#1a1a2e; }
    .btn-outline:hover { border-color:#66bb6a; color:#1b5e20; background:#e8f5e9; }

    .card { background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); padding:20px; box-shadow:var(--shadow); }
    .table-wrap { overflow-x:auto; border-radius:8px; }
    table { width:100%; border-collapse:collapse; font-size:13px; }
    thead th { 
      background:#f8f9fa; color:#4a5a6a; padding:12px 14px; text-align:left; 
      font-weight:600; font-size:11px; text-transform:uppercase; letter-spacing:.5px; 
      white-space:nowrap; border-bottom:2px solid #e8ecf1;
    }
    tbody tr { border-bottom:1px solid #f0f2f5; transition:background .15s; }
    tbody tr:hover { background:#f8f9fa; }
    tbody td { padding:12px 14px; color:#1a1a2e; vertical-align:middle; }
    
    .avatar-sm { 
      width:32px; height:32px; border-radius:50%; 
      background:linear-gradient(135deg, var(--green-500), var(--green-700)); 
      display:inline-flex; align-items:center; justify-content:center; 
      color:#fff; font-size:12px; font-weight:600; margin-right:8px; 
    }
    .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:500; }
    .badge-green  { background:#e8f5e9; color:#2e7d32; }
    .badge-red    { background:#fde8e8; color:#c62828; }
    .badge-orange { background:#fff3e0; color:#e65100; }
    .badge-blue   { background:#e3f2fd; color:#0d47a1; }
    .badge-purple { background:#f3e5f5; color:#4a148c; }
    .badge-gray   { background:#f5f5f5; color:#616161; }

    .charts-grid { display:grid; grid-template-columns:1fr 1fr; gap:18px; margin-top:18px; }
    @media(max-width:900px) { .charts-grid { grid-template-columns:1fr; } }
    .chart-card { background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); padding:20px; box-shadow:var(--shadow); }
    .chart-card h3 { font-size:14px; font-weight:600; margin-bottom:16px; color:#1a1a2e; }
    canvas { max-height:240px; }

    .quick-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(150px,1fr)); gap:14px; margin-top:8px; }
    .quick-card { 
      background:#ffffff; border:1px solid #e8ecf1; border-radius:10px; padding:18px 14px; 
      display:flex; flex-direction:column; align-items:center; gap:10px; cursor:pointer; 
      transition:all .2s; text-align:center; box-shadow:var(--shadow);
    }
    .quick-card:hover { transform:translateY(-3px); border-color:#66bb6a; box-shadow:0 4px 20px rgba(46,125,50,.12); }
    .quick-card .qi { width:44px; height:44px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:18px; }
    .quick-card span { font-size:12px; font-weight:500; color:#1a1a2e; }

    .form-group { margin-bottom:16px; }
    .form-group label { display:block; font-size:12px; font-weight:500; color:#4a5a6a; margin-bottom:6px; text-transform:uppercase; letter-spacing:.4px; }
    .form-control { 
      width:100%; background:#ffffff; border:1px solid #d0d7de; border-radius:8px; 
      padding:10px 14px; color:#1a1a2e; font-size:13px; font-family:'Inter',sans-serif; 
      outline:none; transition:border-color .2s; 
    }
    .form-control:focus { border-color:#66bb6a; box-shadow:0 0 0 3px rgba(46,125,50,.1); }

    .notif-item { display:flex; gap:14px; padding:14px 0; border-bottom:1px solid #f0f2f5; }
    .notif-item:last-child { border-bottom:none; }
    .notif-dot { width:10px; height:10px; border-radius:50%; margin-top:5px; flex-shrink:0; }
    .notif-body p { font-size:13.5px; color:#1a1a2e; }
    .notif-body span { font-size:11px; color:#8c9aab; margin-top:3px; display:block; }

    .msg-item { 
      display:flex; align-items:center; gap:12px; padding:12px 0; 
      border-bottom:1px solid #f0f2f5; cursor:pointer; transition:background .15s; border-radius:8px; 
    }
    .msg-item:hover { background:#f8f9fa; padding-left:8px; }
    .msg-body { flex:1; min-width:0; }
    .msg-body h4 { font-size:13.5px; font-weight:600; color:#1a1a2e; }
    .msg-body p { font-size:12px; color:#6a7a8a; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .msg-meta { text-align:right; flex-shrink:0; }
    .msg-meta span { font-size:11px; color:#8c9aab; }
    .msg-unread { width:8px; height:8px; border-radius:50%; background:#2e7d32; margin-top:4px; float:right; }

    .video-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(260px,1fr)); gap:18px; }
    .video-card { 
      background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); 
      overflow:hidden; transition:all .2s; box-shadow:var(--shadow);
    }
    .video-card:hover { transform:translateY(-3px); box-shadow:0 4px 20px rgba(0,0,0,.08); }
    .video-thumb { 
      height:150px; background:linear-gradient(135deg, #e8f5e9, #c8e6c9); 
      display:flex; align-items:center; justify-content:center; font-size:48px; 
      color:rgba(46,125,50,.3); position:relative; overflow:hidden;
    }
    .video-thumb img { width:100%; height:100%; object-fit:cover; }
    .play-btn { 
      position:absolute; width:48px; height:48px; background:rgba(46,125,50,.15); 
      border-radius:50%; display:flex; align-items:center; justify-content:center; 
      color:#2e7d32; font-size:20px; cursor:pointer; transition:all .2s; backdrop-filter:blur(4px); 
    }
    .play-btn:hover { background:rgba(46,125,50,.3); transform:scale(1.1); }
    .video-info { padding:14px; }
    .video-info h4 { font-size:13.5px; font-weight:600; color:#1a1a2e; margin-bottom:4px; }
    .video-info p { font-size:12px; color:#6a7a8a; }

    .animal-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:18px; }
    .animal-card { 
      background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); 
      padding:20px; text-align:center; transition:all .2s; box-shadow:var(--shadow);
    }
    .animal-card:hover { transform:translateY(-3px); border-color:#66bb6a; box-shadow:0 4px 20px rgba(46,125,50,.1); }
    .animal-emoji { font-size:40px; margin-bottom:8px; }
    .animal-card h4 { font-size:15px; font-weight:600; color:#1a1a2e; }
    .animal-card p { font-size:12px; color:#6a7a8a; margin-top:4px; }
    .animal-stat { font-size:20px; font-weight:700; color:#2e7d32; margin-top:8px; }

    .ad-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(280px,1fr)); gap:18px; }
    .ad-card { 
      background:#ffffff; border:1px solid #e8ecf1; border-radius:var(--radius); 
      overflow:hidden; box-shadow:var(--shadow); transition:all .2s;
    }
    .ad-card:hover { transform:translateY(-2px); box-shadow:0 4px 20px rgba(0,0,0,.08); }
    .ad-banner { height:120px; display:flex; align-items:center; justify-content:center; font-size:36px; background:linear-gradient(135deg, #e8f5e9, #c8e6c9); }
    .ad-info { padding:14px; }
    .ad-info h4 { font-size:14px; font-weight:600; color:#1a1a2e; margin-bottom:4px; }
    .ad-info p { font-size:12px; color:#6a7a8a; margin-bottom:10px; }
    .ad-stats { display:flex; gap:16px; flex-wrap:wrap; }
    .ad-stats span { font-size:12px; color:#4a5a6a; }
    .ad-stats span i { margin-right:4px; }

    .gestation-item { 
      display:flex; align-items:center; gap:14px; padding:14px; 
      background:#f8f9fa; border-radius:10px; margin-bottom:12px; border:1px solid #e8ecf1; 
    }
    .gestation-icon { font-size:32px; flex-shrink:0; }
    .gestation-body { flex:1; }
    .gestation-body h4 { font-size:14px; font-weight:600; color:#1a1a2e; }
    .gestation-body p { font-size:12px; color:#6a7a8a; margin-top:2px; }
    .progress-bar { background:#e8ecf1; border-radius:20px; height:6px; margin-top:8px; }
    .progress-fill { height:100%; border-radius:20px; background:linear-gradient(90deg, var(--green-400), var(--green-600)); }
    .progress-pct { font-size:11px; color:#2e7d32; font-weight:600; margin-top:3px; }

    /* Modal Styles */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(0,0,0,0.6);
        z-index: 99999;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(4px);
    }
    .modal-overlay.active { display: flex !important; }
    
    .modal-box {
        background: #ffffff;
        border-radius: 16px;
        width: 95%;
        max-width: 550px;
        max-height: 90vh;
        overflow-y: auto;
        padding: 30px;
        box-shadow: 0 25px 80px rgba(0,0,0,0.4);
        animation: modalSlideIn 0.3s ease;
    }
    
    @keyframes modalSlideIn {
        from { transform: translateY(-40px) scale(0.95); opacity: 0; }
        to { transform: translateY(0) scale(1); opacity: 1; }
    }
    
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #e8ecf1;
    }
    .modal-header h3 { font-size: 20px; font-weight: 700; color: #1a1a2e; margin: 0; }
    .modal-close {
        background: none;
        border: none;
        font-size: 28px;
        cursor: pointer;
        color: #6a7a8a;
        transition: all 0.2s;
        padding: 0 8px;
        line-height: 1;
    }
    .modal-close:hover { color: #dc3545; transform: rotate(90deg); }
    
    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
    }
    @media (max-width: 480px) { .form-row { grid-template-columns: 1fr; } }
    
    .form-group { margin-bottom: 16px; }
    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #1a1a2e;
        margin-bottom: 5px;
    }
    .form-group label .required { color: #dc3545; margin-left: 2px; }
    .form-control {
        width: 100%;
        padding: 10px 14px;
        border: 2px solid #e8ecf1;
        border-radius: 8px;
        font-size: 14px;
        font-family: 'Inter', sans-serif;
        transition: all 0.2s;
        background: #f8f9fa;
        color: #1a1a2e;
    }
    .form-control:focus {
        outline: none;
        border-color: #2e7d32;
        background: #ffffff;
        box-shadow: 0 0 0 4px rgba(46,125,50,0.1);
    }
    
    .modal-footer {
        display: flex;
        gap: 10px;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 2px solid #e8ecf1;
    }
    .modal-footer .btn { flex: 1; padding: 12px 20px; font-size: 14px; }
    .modal-footer .btn-primary {
        background: linear-gradient(135deg, #2e7d32, #1b5e20);
        color: #fff;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }
    .modal-footer .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(46,125,50,0.3);
    }
    .modal-footer .btn-primary:disabled { opacity: 0.7; cursor: not-allowed; transform: none; }
    .modal-footer .btn-outline {
        background: transparent;
        border: 2px solid #e8ecf1;
        color: #1a1a2e;
        border-radius: 8px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
    }
    .modal-footer .btn-outline:hover {
        border-color: #dc3545;
        color: #dc3545;
        background: #fff5f5;
    }

    /* Toast Styles */
    .toast {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 16px 24px;
        border-radius: 8px;
        color: #fff;
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        z-index: 999999;
        animation: slideIn 0.3s ease;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        display: flex;
        align-items: center;
        gap: 12px;
        max-width: 400px;
    }
    .toast-success { background: #2e7d32; }
    .toast-error { background: #dc3545; }
    .toast-warning { background: #fd7e14; }
    .toast-info { background: #0d6efd; }
    @keyframes slideIn {
        from { transform: translateX(100px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }

    @media(max-width:768px) {
      #sidebar { width:var(--sidebar-collapsed); }
      #topbar { left:var(--sidebar-collapsed); }
      #main-wrap { margin-left:var(--sidebar-collapsed); }
      .topbar-search { min-width:120px; }
      .stats-grid { grid-template-columns:1fr 1fr; }
      .charts-grid { grid-template-columns:1fr; }
    }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside id="sidebar">
  <div class="sidebar-logo">
    <div class="logo-icon"><i class="fas fa-seedling"></i></div>
    <div class="logo-text">
      <h1>Jaguza</h1>
      <span>Admin Dashboard</span>
    </div>
  </div>
  <div class="sidebar-scroll">
    <div class="nav-section-label">Overview</div>
    <a class="nav-item active" id="nav-dashboard" onclick="navigate('dashboard','Dashboard Overview')">
      <div class="nav-icon"><i class="fas fa-th-large"></i></div><span class="nav-label">Dashboard</span>
    </a>
    <a class="nav-item" id="nav-analytics" onclick="navigate('analytics','Analytics')">
      <div class="nav-icon"><i class="fas fa-chart-line"></i></div><span class="nav-label">Analytics</span>
    </a>

    <div class="nav-section-label">People</div>
    <a class="nav-item" id="nav-users" onclick="navigate('users','Users')">
      <div class="nav-icon"><i class="fas fa-users"></i></div><span class="nav-label">Users</span>
      <span class="nav-badge">{{ number_format($stats['total_users'] ?? 0) }}</span>
    </a>
    <a class="nav-item" id="nav-doctors" onclick="navigate('doctors','Veterinary Doctors')">
      <div class="nav-icon"><i class="fas fa-stethoscope"></i></div><span class="nav-label">Doctors</span>
    </a>
    
    <a class="nav-item" id="nav-notifications" onclick="navigate('notifications','Notifications')">
      <div class="nav-icon"><i class="fas fa-bell"></i></div><span class="nav-label">Notifications</span>
      <span class="nav-badge">{{ count($notifications ?? []) }}</span>
    </a>

    <div class="nav-section-label">Farm &amp; Animals</div>
    <a class="nav-item" id="nav-farms" onclick="navigate('farms','Farms')">
      <div class="nav-icon"><i class="fas fa-warehouse"></i></div><span class="nav-label">Farms</span>
    </a>
    <a class="nav-item" id="nav-livestock" onclick="navigate('livestock','Livestock Animals')">
      <div class="nav-icon"><i class="fas fa-horse"></i></div><span class="nav-label">Livestock Animals</span>
    </a>
    <a class="nav-item" id="nav-gestation" onclick="navigate('gestation','Gestation Info')">
      <div class="nav-icon"><i class="fas fa-baby"></i></div><span class="nav-label">Gestation Info</span>
    </a>
    <a class="nav-item" id="nav-vaccinations" onclick="navigate('vaccinations','Vaccinations')">
      <div class="nav-icon"><i class="fas fa-syringe"></i></div><span class="nav-label">Vaccinations</span>
    </a>

    <div class="nav-section-label">Health &amp; Disease</div>
    <a class="nav-item" id="nav-sickness" onclick="navigate('sickness','Sickness Reports')">
      <div class="nav-icon"><i class="fas fa-file-medical"></i></div><span class="nav-label">Sickness Reports</span>
      <span class="nav-badge">{{ number_format($stats['open_reports'] ?? 0) }}</span>
    </a>
    <a class="nav-item" id="nav-disease" onclick="navigate('disease','Disease Information')">
      <div class="nav-icon"><i class="fas fa-virus"></i></div><span class="nav-label">Disease Info</span>
    </a>
    <a class="nav-item" id="nav-decision" onclick="navigate('decision','Decision Support')">
      <div class="nav-icon"><i class="fas fa-brain"></i></div><span class="nav-label">Decision Support</span>
    </a>

    <div class="nav-section-label">Market &amp; Media</div>
    <a class="nav-item" id="nav-marketplace" onclick="navigate('marketplace','Market Place')">
      <div class="nav-icon"><i class="fas fa-store"></i></div><span class="nav-label">Market Place</span>
    </a>
    <a class="nav-item" id="nav-videos" onclick="navigate('videos','Videos')">
      <div class="nav-icon"><i class="fas fa-play-circle"></i></div><span class="nav-label">Videos</span>
    </a>
    <a class="nav-item" id="nav-ads" onclick="navigate('ads','Advertisements')">
      <div class="nav-icon"><i class="fas fa-bullhorn"></i></div><span class="nav-label">Advertisements</span>
    </a>

    <div class="nav-section-label">Other</div>
    <a class="nav-item" id="nav-weather" onclick="navigate('weather','Weather Updates')">
      <div class="nav-icon"><i class="fas fa-cloud-sun"></i></div><span class="nav-label">Weather Updates</span>
    </a>
    <a class="nav-item" id="nav-aichat" onclick="navigate('aichat','AI Chat (Vet Bot)')">
      <div class="nav-icon"><i class="fas fa-robot"></i></div><span class="nav-label">AI Chat (Vet Bot)</span>
    </a>
    <a class="nav-item" id="nav-settings" onclick="navigate('settings','Settings')">
      <div class="nav-icon"><i class="fas fa-cog"></i></div><span class="nav-label">Settings</span>
    </a>
  </div>
  <div class="sidebar-footer">
    <div class="sidebar-user">
      <div class="user-avatar">{{ getInitials($user->name ?? 'JA') }}</div>
      <div class="user-info">
        <p>{{ $user->name ?? 'Jaguza Admin' }}</p>
        <span>{{ ucfirst($user->role ?? 'Super Admin') }}</span>
      </div>
    </div>
    <form method="POST" action="{{ route('logout') }}" style="margin-top:10px;">
      @csrf
      <button type="submit" style="background:none;border:none;color:#dc3545;cursor:pointer;font-size:13px;width:100%;padding:8px;border-radius:8px;transition:background 0.2s;font-family:'Inter',sans-serif;"
              onmouseover="this.style.background='#fde8e8'" 
              onmouseout="this.style.background='transparent'">
          <i class="fas fa-sign-out-alt"></i> Logout
      </button>
    </form>
  </div>
</aside>

<!-- TOPBAR -->
<header id="topbar">
  <div class="topbar-left">
    <button id="toggle-btn" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <span id="page-title">Dashboard Overview</span>
  </div>
  <div class="topbar-search">
    <i class="fas fa-search"></i>
    <input type="text" placeholder="Search anything..." id="globalSearch" />
  </div>
  <div class="topbar-right">
    <button class="topbar-action-btn" onclick="navigate('notifications','Notifications')">
      <i class="fas fa-bell"></i>
      <span class="topbar-badge">{{ count($notifications ?? []) }}</span>
    </button>
    

  </div>
</header>

<!-- MAIN CONTENT -->
<div id="main-wrap">

  <!-- ===== DASHBOARD ===== -->
  <div class="page active" id="page-dashboard">
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-users"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_users'] ?? 0) }}</h3>
          <p>Total Users</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($userGrowthPercent ?? 0, 1) }}% this month</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fde8e8;color:#c62828;"><i class="fas fa-file-medical"></i></div>
        <div class="stat-body">
          <h3>{{ number_format(($stats['open_reports'] ?? 0) + ($stats['under_treatment'] ?? 0)) }}</h3>
          <p>Sickness Reports</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($sicknessGrowthPercent ?? 0, 1) }}% this week</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-stethoscope"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_doctors'] ?? 0) }}</h3>
          <p>Active Doctors</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($newDoctors ?? 0) }} new this month</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-warehouse"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_farms'] ?? 0) }}</h3>
          <p>Registered Farms</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($farmGrowthPercent ?? 0, 1) }}% growth</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#f3e5f5;color:#4a148c;"><i class="fas fa-horse"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_animals'] ?? 0) }}</h3>
          <p>Livestock Animals</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($livestockGrowthPercent ?? 0, 1) }}% new</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-play-circle"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_videos'] ?? 0) }}</h3>
          <p>Videos Published</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($newVideosThisWeek ?? 0) }} this week</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#f5f5f5;color:#f57c00;"><i class="fas fa-bullhorn"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['active_ads'] ?? 0) }}</h3>
          <p>Active Ads</p>
          <div class="stat-trend trend-down"><i class="fas fa-arrow-down"></i> {{ number_format($expiredAds ?? 0) }} expired</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fce4ec;color:#c62828;"><i class="fas fa-baby"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_gestations'] ?? 0) }}</h3>
          <p>Gestation Records</p>
          <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> {{ number_format($dueGestationsCount ?? 0) }} due this week</div>
        </div>
      </div>
    </div>
    
    <div class="charts-grid">
      <div class="chart-card">
        <h3><i class="fas fa-chart-bar" style="color:#2e7d32;margin-right:8px;"></i>Sickness Reports (Monthly)</h3>
        <canvas id="sickChart"></canvas>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-chart-pie" style="color:#0d6efd;margin-right:8px;"></i>Livestock by Type</h3>
        <canvas id="animalChart"></canvas>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-chart-line" style="color:#2e7d32;margin-right:8px;"></i>User Registrations</h3>
        <canvas id="userChart"></canvas>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-store" style="color:#fd7e14;margin-right:8px;"></i>Market Activity</h3>
        <canvas id="marketChart"></canvas>
      </div>
    </div>
    
    <div class="section-heading" style="margin-top:28px;"><h2>Quick Actions</h2></div>
    <div class="quick-grid">
      <div class="quick-card" onclick="openAddUserModal()">
        <div class="qi" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-user-plus"></i></div>
        <span>Add User</span>
      </div>
      <div class="quick-card" onclick="openAddReportModal()">
        <div class="qi" style="background:#fde8e8;color:#c62828;"><i class="fas fa-file-medical"></i></div>
        <span>New Report</span>
      </div>
      <div class="quick-card" onclick="openAddDoctorModal()">
        <div class="qi" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-stethoscope"></i></div>
        <span>Add Doctor</span>
      </div>
      <div class="quick-card" onclick="openAddAnimalModal()">
        <div class="qi" style="background:#f3e5f5;color:#4a148c;"><i class="fas fa-horse"></i></div>
        <span>Add Animal</span>
      </div>
      <div class="quick-card" onclick="openAddAdModal()">
        <div class="qi" style="background:#f5f5f5;color:#f57c00;"><i class="fas fa-bullhorn"></i></div>
        <span>New Ad</span>
      </div>
      <div class="quick-card" onclick="openAddVideoModal()">
        <div class="qi" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-upload"></i></div>
        <span>Upload Video</span>
      </div>
      <div class="quick-card" onclick="openAddGestationModal()">
        <div class="qi" style="background:#fce4ec;color:#c62828;"><i class="fas fa-baby"></i></div>
        <span>Add Gestation</span>
      </div>
      <div class="quick-card" onclick="openAddNotificationModal()">
        <div class="qi" style="background:#fff3e0;color:#e65100;"><i class="fas fa-paper-plane"></i></div>
        <span>Send Notification</span>
      </div>
    </div>
  </div>

  <div class="page" id="page-users">
    <div class="section-heading">
      <h2><i class="fas fa-users" style="color:#2e7d32;margin-right:8px;"></i>Users Management</h2>
      <button class="btn btn-primary" onclick="openAddUserModal()">+ Add User</button>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead>
            <tr><th>#</th><th>User</th><th>Email</th><th>Farm</th><th>Role</th><th>Status</th><th>Joined</th><th>Actions</th></tr>
          </thead>
          <tbody>
            @forelse($users as $user)
            <tr>
              <td>{{ $loop->iteration }}</td>
              <td><span class="avatar-sm">{{ getInitials($user->name) }}</span> {{ $user->name }}</td>
              <td>{{ $user->email }}</td>
              <td>{{ $user->farm_name ?? '-' }}</td>
              <td><span class="badge badge-purple">{{ ucfirst($user->role ?? 'Farmer') }}</span></td>
              <td><span class="badge {{ ($user->is_active ?? true) ? 'badge-green' : 'badge-red' }}">{{ ($user->is_active ?? true) ? 'Active' : 'Inactive' }}</span></td>
              <td>{{ $user->created_at ? $user->created_at->format('M d, Y') : 'N/A' }}</td>
              <td>
                <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" onclick="editUser({{ $user->id }})">Edit</button>
                <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" onclick="deleteUser({{ $user->id }})">Delete</button>
              </td>
            </tr>
            @empty
            <tr><td colspan="8" style="text-align:center;padding:40px;color:#6a7a8a;">No users found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== DOCTORS ===== -->
  <div class="page" id="page-doctors">
    <div class="section-heading">
      <h2><i class="fas fa-stethoscope" style="color:#0d6efd;margin-right:8px;"></i>Veterinary Doctors</h2>
      <button class="btn btn-primary" onclick="openAddDoctorModal()">+ Add Doctor</button>
    </div>
    
    <!-- Doctor Stats -->
    <div class="stats-grid" style="margin-bottom:20px;">
      <div class="stat-card">
        <div class="stat-icon" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-user-md"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($stats['total_doctors'] ?? 0) }}</h3>
          <p>Total Doctors</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-check-circle"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($available_doctors ?? 0) }}</h3>
          <p>Available Now</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-clock"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($busy_doctors ?? 0) }}</h3>
          <p>Busy/Unavailable</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fce4ec;color:#c62828;"><i class="fas fa-file-medical"></i></div>
        <div class="stat-body">
          <h3>{{ number_format($total_cases ?? 0) }}</h3>
          <p>Total Cases Handled</p>
        </div>
      </div>
    </div>
    
    <!-- Doctors Table -->
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Doctor</th>
              <th>Specialization</th>
              <th>License</th>
              <th>Location</th>
              <th>Experience</th>
              <th>Cases</th>
              <th>Availability</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            @forelse($doctors as $doctor)
            <tr>
              <td>{{ $loop->iteration }}</td>
              <td>
                <span class="avatar-sm">{{ getInitials($doctor->user->name ?? '') }}</span> 
                {{ $doctor->user->name ?? 'N/A' }}
                <br><small style="color:#6a7a8a;font-size:11px;">{{ $doctor->user->email ?? 'N/A' }}</small>
              </td>
              <td><span class="badge badge-blue">{{ $doctor->specialization ?? 'N/A' }}</span></td>
              <td>{{ $doctor->license_number ?? 'N/A' }}</td>
              <td>{{ $doctor->clinic_location ?? $doctor->location ?? 'N/A' }}</td>
              <td>{{ $doctor->years_of_experience ?? 0 }} yrs</td>
              <td>
                <span class="badge badge-purple">{{ number_format($doctor->cases_count ?? 0) }}</span>
              </td>
              <td>
                @php
                  $isAvailable = $doctor->is_available ?? true;
                @endphp
                <span class="badge {{ $isAvailable ? 'badge-green' : 'badge-red' }}" onclick="toggleDoctorAvailability({{ $doctor->id }}, {{ $isAvailable ? 'true' : 'false' }})" style="cursor:pointer;">
                  <i class="fas {{ $isAvailable ? 'fa-circle' : 'fa-circle' }}"></i> 
                  {{ $isAvailable ? 'Available' : 'Busy' }}
                </span>
                <br><small style="color:#6a7a8a;font-size:10px;">click to toggle</small>
              </td>
              <td>
                <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" onclick="editDoctor({{ $doctor->id }})">
                  <i class="fas fa-edit"></i> Edit
                </button>
                <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" onclick="deleteDoctor({{ $doctor->id }})">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
            </tr>
            @empty
            <tr>
              <td colspan="9" style="text-align:center;padding:40px;color:#6a7a8a;">
                <i class="fas fa-stethoscope" style="font-size:40px;display:block;margin-bottom:10px;color:#c8d0d8;"></i>
                No doctors found. Click the "Add Doctor" button to register a new veterinary doctor.
              </td>
            </tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== SICKNESS REPORTS ===== -->
  <div class="page" id="page-sickness">
    <div class="section-heading">
      <h2><i class="fas fa-file-medical" style="color:#dc3545;margin-right:8px;"></i>Sickness Reports</h2>
      <button class="btn btn-primary" onclick="openAddReportModal()">+ New Report</button>
    </div>
    <div class="stats-grid" style="margin-bottom:20px;">
      <div class="stat-card"><div class="stat-icon" style="background:#fde8e8;color:#c62828;"><i class="fas fa-exclamation-circle"></i></div><div class="stat-body"><h3>{{ number_format($stats['open_reports'] ?? 0) }}</h3><p>Open Cases</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-clock"></i></div><div class="stat-body"><h3>{{ number_format($stats['under_treatment'] ?? 0) }}</h3><p>Under Treatment</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-check-circle"></i></div><div class="stat-body"><h3>{{ number_format($stats['resolved_reports'] ?? 0) }}</h3><p>Resolved</p></div></div>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>#</th><th>Animal</th><th>Farm</th><th>Symptoms</th><th>Reported By</th><th>Date</th><th>Status</th><th>Doctor</th></tr></thead>
          <tbody>
            @forelse($recentReports as $report)
            <tr>
              <td>{{ $report->report_id ?? '#' }}</td>
              <td>{{ $report->animal->name ?? $report->animal->identification_number ?? 'N/A' }}</td>
              <td>{{ $report->animal->farm->name ?? 'N/A' }}</td>
              <td>{{ Str::limit($report->symptoms ?? '', 30) }}</td>
              <td>{{ $report->reporter->name ?? 'Unknown' }}</td>
              <td>{{ $report->created_at ? $report->created_at->format('M d, Y') : 'N/A' }}</td>
              <td><span class="badge {{ getStatusBadge($report->status ?? '') }}">{{ getStatusDisplay($report->status ?? '') }}</span></td>
              <td>{{ $report->doctor->name ?? ($report->doctor->user->name ?? 'Unassigned') }}</td>
            </tr>
            @empty
            <tr><td colspan="8" style="text-align:center;padding:40px;color:#6a7a8a;">No sickness reports found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== DISEASE INFO ===== -->
  <div class="page" id="page-disease">
    <div class="section-heading">
      <h2><i class="fas fa-virus" style="color:#fd7e14;margin-right:8px;"></i>Disease Information</h2>
      <button class="btn btn-primary" onclick="openAddDiseaseModal()">+ Add Disease</button>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>Disease</th><th>Species Affected</th><th>Symptoms</th><th>Treatment</th><th>Severity</th><th>Outbreak Risk</th></tr></thead>
          <tbody>
            @forelse($diseases as $disease)
            <tr>
              <td><strong style="color:#1a1a2e;">{{ $disease->name }}</strong></td>
              <td>{{ $disease->species_affected ?? 'N/A' }}</td>
              <td>{{ Str::limit($disease->symptoms ?? '', 50) }}</td>
              <td>{{ Str::limit($disease->treatment ?? '', 50) }}</td>
              <td><span class="badge @if($disease->severity == 'high' || $disease->severity == 'critical') badge-red @elseif($disease->severity == 'medium') badge-orange @else badge-green @endif">{{ ucfirst($disease->severity ?? 'Unknown') }}</span></td>
              <td><span class="badge @if($disease->outbreak_risk == 'high') badge-red @elseif($disease->outbreak_risk == 'medium') badge-orange @else badge-green @endif">{{ ucfirst($disease->outbreak_risk ?? 'Unknown') }}</span></td>
            </tr>
            @empty
            <tr><td colspan="6" style="text-align:center;padding:40px;color:#6a7a8a;">No diseases found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>
<!-- ===== FARM MODAL ===== -->
<div class="modal-overlay" id="farmModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="farmModalTitle">Add New Farm</h3>
            <button class="modal-close" onclick="closeModal('farmModal')">&times;</button>
        </div>
        <form id="farmForm" onsubmit="event.preventDefault(); saveFarm();">
            <input type="hidden" id="farmId">
            
            <div class="form-group">
                <label>Farm Name <span class="required">*</span></label>
                <input type="text" id="farm_name" class="form-control" placeholder="Green Valley Farm" required>
            </div>
            
            <div class="form-group">
                <label>Owner Name <span class="required">*</span></label>
                <input type="text" id="farm_owner" class="form-control" placeholder="John Mukasa" required>
            </div>
            
            <div class="form-group">
                <label>Location <span class="required">*</span></label>
                <input type="text" id="farm_location" class="form-control" placeholder="Wakiso, Uganda" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Farm Size</label>
                    <input type="text" id="farm_size" class="form-control" placeholder="50 acres">
                </div>
                <div class="form-group">
                    <label>Established Year</label>
                    <input type="text" id="farm_established" class="form-control" placeholder="2018">
                </div>
            </div>
            
            <div class="form-group">
                <label>GPS Coordinates</label>
                <input type="text" id="farm_coordinates" class="form-control" placeholder="0.3136° N, 32.5811° E">
            </div>
            
            <div class="form-group">
                <label>Description</label>
                <textarea id="farm_description" class="form-control" rows="3" placeholder="Describe your farm..."></textarea>
            </div>
            
            <div class="form-group">
                <label>Facilities</label>
                <div id="facilitiesContainer" style="display:flex;flex-wrap:wrap;gap:8px;padding:8px;border:1px solid #e8ecf1;border-radius:8px;min-height:44px;">
                    <span style="color:#6a7a8a;font-size:12px;padding:4px 0;">Select facilities from dropdown</span>
                </div>
                <select id="facilitySelect" class="form-control" style="margin-top:8px;" onchange="addFacility()">
                    <option value="">Select a facility...</option>
                    <option value="Barn">Barn</option>
                    <option value="Milking Parlor">Milking Parlor</option>
                    <option value="Poultry House">Poultry House</option>
                    <option value="Store">Store</option>
                    <option value="Silo">Silo</option>
                    <option value="Greenhouse">Greenhouse</option>
                    <option value="Irrigation System">Irrigation System</option>
                    <option value="Fencing">Fencing</option>
                    <option value="Water Tanks">Water Tanks</option>
                    <option value="Solar Panels">Solar Panels</option>
                    <option value="Processing Unit">Processing Unit</option>
                    <option value="Office">Office</option>
                </select>
            </div>
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="farmSubmitBtn">Save Farm</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('farmModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
<!-- ===== FARMS ===== -->
<div class="page" id="page-farms">
    <div class="section-heading">
        <h2><i class="fas fa-warehouse" style="color:#fd7e14;margin-right:8px;"></i>Farms</h2>
        <button class="btn btn-primary" onclick="openAddFarmModal()">+ Add Farm</button>
    </div>
    
    <!-- Farm Stats -->
    <div class="stats-grid" style="margin-bottom:20px;">
        <div class="stat-card">
            <div class="stat-icon" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-warehouse"></i></div>
            <div class="stat-body">
                <h3>{{ number_format($total_farms ?? 0) }}</h3>
                <p>Total Farms</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-check-circle"></i></div>
            <div class="stat-body">
                <h3>{{ number_format($active_farms ?? 0) }}</h3>
                <p>Active Farms</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#fce4ec;color:#c62828;"><i class="fas fa-times-circle"></i></div>
            <div class="stat-body">
                <h3>{{ number_format(($total_farms ?? 0) - ($active_farms ?? 0)) }}</h3>
                <p>Inactive Farms</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#f3e5f5;color:#4a148c;"><i class="fas fa-pets"></i></div>
            <div class="stat-body">
                <h3>{{ number_format($total_animals_on_farms ?? 0) }}</h3>
                <p>Total Animals</p>
            </div>
        </div>
    </div>
    
    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Farm</th>
                        <th>Owner</th>
                        <th>Location</th>
                        <th>Size</th>
                        <th>Animals</th>
                        <th>Established</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($farms as $farm)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>
                            <span style="font-weight:600;">{{ $farm->name }}</span>
                            @if($farm->facilities)
                            <br><small style="color:#6a7a8a;font-size:10px;">
                                @foreach($farm->facilities as $facility)
                                <span class="badge badge-blue" style="font-size:9px;padding:1px 6px;">{{ $facility }}</span>
                                @endforeach
                            </small>
                            @endif
                        </td>
                        <td><strong>{{ $farm->farm_name }}</strong></td>
                        <td>{{ $farm->owner_name ?? $farm->user->name ?? 'N/A' }}</td>
                        <td>{{ $farm->location }}</td>
                        <td>{{ $farm->size ?? 'N/A' }}</td>
                        <td><strong>{{ $farm->farm_name ?? $farm->name ?? 'N/A' }}</strong></td>
                        <td>
                            <span class="badge badge-purple">{{ number_format($farm->animals->count() ?? 0) }}</span>
                        </td>
                        <td>{{ $farm->established_year ?? 'N/A' }}</td>
                        <td>
                            <span class="badge {{ ($farm->is_active ?? true) ? 'badge-green' : 'badge-red' }}">
                                {{ ($farm->is_active ?? true) ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" 
                                    onclick="editFarm({{ $farm->id }})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" 
                                    onclick="deleteFarm({{ $farm->id }})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="9" style="text-align:center;padding:40px;color:#6a7a8a;">
                            <i class="fas fa-warehouse" style="font-size:48px;display:block;margin-bottom:16px;color:#e8ecf1;"></i>
                            <h3 style="color:#1a1a2e;margin-bottom:8px;">No Farms Found</h3>
                            <p>Click "Add Farm" to create your first farm.</p>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
  

  <!-- ===== LIVESTOCK ===== -->
  <div class="page" id="page-livestock">
    <div class="section-heading">
      <h2><i class="fas fa-horse" style="color:#2e7d32;margin-right:8px;"></i>Livestock Animals</h2>
      <button class="btn btn-primary" onclick="openAddAnimalModal()">+ Add Animal</button>
    </div>
    <div class="animal-grid" style="margin-bottom:24px;">
      @forelse($livestockByType as $type => $count)
      <div class="animal-card">
        <div class="animal-emoji">
          @switch($type)
            @case('cattle') &#x1F404; @break
            @case('goat') &#x1F410; @break
            @case('sheep') &#x1F411; @break
            @case('pig') &#x1F416; @break
            @case('poultry') &#x1F414; @break
            @case('rabbit') &#x1F407; @break
            @default &#x1F43E;
          @endswitch
        </div>
        <h4>{{ ucfirst($type) }}</h4>
        <p>Livestock</p>
        <div class="animal-stat">{{ number_format($count) }}</div>
      </div>
      @empty
      <div class="animal-card"><div class="animal-emoji">&#x1F43E;</div><h4>No Animals</h4><p>Add your first animal</p><div class="animal-stat">0</div></div>
      @endforelse
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>ID</th><th>Animal</th><th>Breed</th><th>Age</th><th>Farm</th><th>Health</th><th>Last Checkup</th></tr></thead>
          <tbody>
            @forelse($animals as $animal)
            <tr>
              <td>{{ $animal->identification_number ?? 'N/A' }}</td>
              <td>{{ $animal->name ?? 'N/A' }}</td>
              <td>{{ ucfirst($animal->breed ?? 'N/A') }}</td>
              <td>{{ $animal->age ?? '0' }} {{ ($animal->age ?? 0) > 1 ? 'yrs' : 'yr' }}</td>
              <td>{{ $animal->farm->name ?? 'N/A' }}</td>
              <td><span class="badge @if($animal->health_status == 'healthy') badge-green @elseif($animal->health_status == 'sick' || $animal->health_status == 'critical') badge-red @else badge-orange @endif">{{ ucfirst($animal->health_status ?? 'Unknown') }}</span></td>
              <td>{{ $animal->updated_at ? $animal->updated_at->format('M d, Y') : 'N/A' }}</td>
            </tr>
            @empty
            <tr><td colspan="7" style="text-align:center;padding:40px;color:#6a7a8a;">No animals found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== VIDEOS ===== -->
  <div class="page" id="page-videos">
    <div class="section-heading">
      <h2><i class="fas fa-play-circle" style="color:#2e7d32;margin-right:8px;"></i>Educational Videos</h2>
      <button class="btn btn-primary" onclick="openAddVideoModal()">+ Upload Video</button>
    </div>
    <div class="video-grid">
      @forelse($recentVideos as $video)
      <div class="video-card">
        <div class="video-thumb">
          @if($video->thumbnail_url)<img src="{{ $video->thumbnail_url }}" alt="{{ $video->title }}">@else<i class="fas fa-video"></i>@endif
          <div class="play-btn" onclick="playVideo({{ $video->id }})"><i class="fas fa-play"></i></div>
        </div>
        <div class="video-info">
          <h4>{{ $video->title }}</h4>
          <p>{{ $video->duration ?? 'N/A' }} &bull; {{ number_format($video->views_count ?? 0) }} views &bull; {{ $video->created_at ? $video->created_at->format('M d') : 'N/A' }}</p>
        </div>
      </div>
      @empty
      <div class="video-card"><div class="video-thumb"><i class="fas fa-video"></i></div><div class="video-info"><h4>No videos available</h4><p>Upload educational videos for farmers</p></div></div>
      @endforelse
    </div>
  </div>

  <!-- ===== ADVERTISEMENTS ===== -->
  <div class="page" id="page-ads">
    <div class="section-heading">
      <h2><i class="fas fa-bullhorn" style="color:#f57c00;margin-right:8px;"></i>Advertisements</h2>
      <button class="btn btn-primary" onclick="openAddAdModal()">+ Create Ad</button>
    </div>
    <div class="ad-grid">
      @forelse($activeAds as $ad)
      <div class="ad-card">
        <div class="ad-banner">📢</div>
        <div class="ad-info">
          <h4>{{ $ad->title }}</h4>
          <p>{{ Str::limit($ad->description ?? '', 80) }}</p>
          <div class="ad-stats">
            <span style="color:#2e7d32;"><i class="fas fa-eye"></i> {{ number_format($ad->views_count ?? 0) }}</span>
            <span style="color:#0d6efd;"><i class="fas fa-mouse-pointer"></i> {{ number_format($ad->clicks_count ?? 0) }}</span>
            <span class="badge {{ $ad->status == 'active' ? 'badge-green' : 'badge-orange' }}">{{ ucfirst($ad->status ?? 'Draft') }}</span>
          </div>
        </div>
      </div>
      @empty
      <div class="ad-card"><div class="ad-info"><h4>No active ads</h4><p>Create your first advertisement</p></div></div>
      @endforelse
    </div>
  </div>

  <!-- ===== GESTATION ===== -->
  <div class="page" id="page-gestation">
    <div class="section-heading">
      <h2><i class="fas fa-baby" style="color:#dc3545;margin-right:8px;"></i>Gestation Information</h2>
      <button class="btn btn-primary" onclick="openAddGestationModal()">+ Add Record</button>
    </div>
    <div class="stats-grid" style="margin-bottom:20px;">
      <div class="stat-card"><div class="stat-icon" style="background:#fde8e8;color:#c62828;"><i class="fas fa-clock"></i></div><div class="stat-body"><h3>{{ number_format($dueGestationsCount ?? 0) }}</h3><p>Due This Week</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-calendar-alt"></i></div><div class="stat-body"><h3>{{ number_format($dueGestationsThisMonth ?? 0) }}</h3><p>Due This Month</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-check-double"></i></div><div class="stat-body"><h3>{{ number_format($stats['total_gestations'] ?? 0) }}</h3><p>Total Active</p></div></div>
    </div>
    <div class="card">
      @forelse($dueGestations as $gestation)
      <div class="gestation-item">
        <div class="gestation-icon">
          @if($gestation->animal->type == 'cattle') &#x1F404;
          @elseif($gestation->animal->type == 'goat') &#x1F410;
          @elseif($gestation->animal->type == 'sheep') &#x1F411;
          @elseif($gestation->animal->type == 'pig') &#x1F416;
          @else &#x1F43E;
          @endif
        </div>
        <div class="gestation-body">
          <h4>{{ ucfirst($gestation->animal->type ?? 'Animal') }} – {{ $gestation->animal->name ?? $gestation->animal->identification_number ?? 'Unknown' }}
            @php $daysLeft = now()->diffInDays($gestation->expected_delivery_date, false); @endphp
            @if($daysLeft <= 3)<span class="badge badge-red">Due in {{ $daysLeft }} days</span>
            @elseif($daysLeft <= 14)<span class="badge badge-orange">Due in {{ $daysLeft }} days</span>
            @else<span class="badge badge-blue">Due in {{ $daysLeft }} days</span>@endif
          </h4>
          <p>Farm: {{ $gestation->animal->farm->name ?? 'N/A' }} · Mated: {{ $gestation->mating_date ? $gestation->mating_date->format('M d, Y') : 'N/A' }} · Expected: {{ $gestation->expected_delivery_date ? $gestation->expected_delivery_date->format('M d, Y') : 'N/A' }}</p>
          @php
            $totalDays = $gestation->mating_date ? now()->diffInDays($gestation->expected_delivery_date) : 280;
            $daysPassed = $gestation->mating_date ? $gestation->mating_date->diffInDays(now()) : 0;
            $progress = $totalDays > 0 ? min(100, round(($daysPassed / $totalDays) * 100)) : 0;
          @endphp
          <div class="progress-bar"><div class="progress-fill" style="width:{{ $progress }}%;"></div></div>
          <div class="progress-pct">{{ $progress }}% Complete</div>
        </div>
      </div>
      @empty
      <div style="text-align:center;padding:40px;color:#6a7a8a;"><p>No gestation records found.</p></div>
      @endforelse
    </div>
  </div>

  <!-- ===== NOTIFICATIONS ===== -->
  <div class="page" id="page-notifications">
    <div class="section-heading">
      <h2><i class="fas fa-bell" style="color:#fd7e14;margin-right:8px;"></i>Notifications</h2>
      <button class="btn btn-primary" onclick="openAddNotificationModal()">+ Send Notification</button>
    </div>
    <div class="card">
      @forelse($notifications as $notification)
      <div class="notif-item">
        <div class="notif-dot" style="background:{{ $notification->color ?? '#2e7d32' }};"></div>
        <div class="notif-body">
          <p><strong style="color:#1a1a2e;">{{ $notification->title ?? 'Notification' }}:</strong> {{ $notification->message ?? '' }}</p>
          <span>{{ $notification->created_at ? $notification->created_at->diffForHumans() : 'N/A' }}</span>
        </div>
      </div>
      @empty
      <div style="text-align:center;padding:40px;color:#6a7a8a;"><p>No notifications found.</p></div>
      @endforelse
    </div>
  </div>



  <!-- ===== ANALYTICS ===== -->
  <div class="page" id="page-analytics">
    <div class="section-heading">
      <h2><i class="fas fa-chart-line" style="color:#2e7d32;margin-right:8px;"></i>Analytics</h2>
      <button class="btn btn-outline" onclick="exportReport()">Export Report</button>
    </div>
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-users"></i></div><div class="stat-body"><h3>{{ number_format($stats['total_users'] ?? 0) }}</h3><p>Total Users</p><div class="stat-trend trend-up">{{ number_format($userGrowthPercent ?? 0, 1) }}% growth</div></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-eye"></i></div><div class="stat-body"><h3>148K</h3><p>Monthly App Opens</p><div class="stat-trend trend-up">22.1% growth</div></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-store"></i></div><div class="stat-body"><h3>UGX 42M</h3><p>Market Volume</p><div class="stat-trend trend-up">18.3% growth</div></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#f3e5f5;color:#4a148c;"><i class="fas fa-play-circle"></i></div><div class="stat-body"><h3>{{ number_format($stats['total_videos'] ?? 0) }}</h3><p>Video Views</p><div class="stat-trend trend-up">31.2% growth</div></div></div>
    </div>
    <div class="charts-grid">
      <div class="chart-card"><h3>User Growth (12 Months)</h3><canvas id="userGrowthChart"></canvas></div>
      <div class="chart-card"><h3>Disease Cases by Type</h3><canvas id="diseaseChart"></canvas></div>
    </div>
  </div>

  <!-- ===== VACCINATIONS ===== -->
  <div class="page" id="page-vaccinations">
    <div class="section-heading">
      <h2><i class="fas fa-syringe" style="color:#0d6efd;margin-right:8px;"></i>Vaccinations</h2>
      <button class="btn btn-primary" onclick="openAddVaccinationModal()">+ Add Record</button>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>ID</th><th>Animal</th><th>Vaccine</th><th>Farm</th><th>Administered By</th><th>Date</th><th>Next Due</th><th>Status</th></tr></thead>
          <tbody>
            @forelse($vaccinations as $vaccination)
            <tr>
              <td>{{ $vaccination->id ?? 'N/A' }}</td>
              <td>{{ $vaccination->animal->name ?? $vaccination->animal->identification_number ?? 'N/A' }}</td>
              <td>{{ $vaccination->vaccine_name ?? 'N/A' }}</td>
              <td>{{ $vaccination->animal->farm->name ?? 'N/A' }}</td>
              <td>{{ $vaccination->administeredBy->user->name ?? 'N/A' }}</td>
              <td>{{ $vaccination->administered_date ? $vaccination->administered_date->format('M d, Y') : 'N/A' }}</td>
              <td>{{ $vaccination->next_due_date ? $vaccination->next_due_date->format('M d, Y') : 'N/A' }}</td>
              <td><span class="badge {{ $vaccination->next_due_date && $vaccination->next_due_date->isPast() ? 'badge-red' : ($vaccination->is_completed ? 'badge-green' : 'badge-orange') }}">{{ $vaccination->next_due_date && $vaccination->next_due_date->isPast() ? 'Overdue' : ($vaccination->is_completed ? 'Done' : 'Due Soon') }}</span></td>
            </tr>
            @empty
            <tr><td colspan="8" style="text-align:center;padding:40px;color:#6a7a8a;">No vaccination records found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== MARKETPLACE ===== -->
  <div class="page" id="page-marketplace">
    <div class="section-heading">
      <h2><i class="fas fa-store" style="color:#fd7e14;margin-right:8px;"></i>Market Place</h2>
      <button class="btn btn-primary" onclick="openAddListingModal()">+ Add Listing</button>
    </div>
    <div class="card">
      <div class="table-wrap">
        <table>
          <thead><tr><th>#</th><th>Listing</th><th>Seller</th><th>Category</th><th>Price</th><th>Location</th><th>Status</th></tr></thead>
          <tbody>
            @forelse($marketplaceListings as $listing)
            <tr>
              <td>{{ $loop->iteration }}</td>
              <td>{{ $listing->title ?? 'N/A' }}</td>
              <td>{{ $listing->seller->name ?? 'N/A' }}</td>
              <td><span class="badge badge-green">{{ ucfirst($listing->category ?? 'General') }}</span></td>
              <td>{{ $listing->currency ?? 'UGX' }} {{ number_format($listing->price ?? 0) }}</td>
              <td>{{ $listing->location ?? 'N/A' }}</td>
              <td><span class="badge @if($listing->status == 'active') badge-green @elseif($listing->status == 'pending') badge-orange @else badge-red @endif">{{ ucfirst($listing->status ?? 'Unknown') }}</span></td>
            </tr>
            @empty
            <tr><td colspan="7" style="text-align:center;padding:40px;color:#6a7a8a;">No marketplace listings found.</td></tr>
            @endforelse
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ===== WEATHER ===== -->
  <div class="page" id="page-weather">
    <div class="section-heading">
      <h2><i class="fas fa-cloud-sun" style="color:#f57c00;margin-right:8px;"></i>Weather Updates</h2>
      <button class="btn btn-outline" onclick="refreshWeather()"><i class="fas fa-sync"></i> Refresh</button>
    </div>
    <div class="stats-grid">
      @forelse($weatherUpdates as $weather)
      <div class="stat-card">
        <div class="stat-icon" style="font-size:28px;background:{{ $weather->condition == 'Sunny' ? '#fff3e0' : ($weather->condition == 'Rain' ? '#e3f2fd' : '#f0f2f5') }};">
          @if($weather->condition == 'Sunny') &#x2600;&#xFE0F;
          @elseif($weather->condition == 'Rain') &#x1F327;&#xFE0F;
          @elseif($weather->condition == 'Cloudy') &#x26C5;
          @elseif($weather->condition == 'Hot') &#x1F324;&#xFE0F;
          @else &#x1F31E;
          @endif
        </div>
        <div class="stat-body">
          <h3>{{ number_format($weather->temperature ?? 0) }}&deg;C</h3>
          <p>{{ $weather->location ?? 'Unknown' }} – {{ $weather->condition ?? 'N/A' }}</p>
        </div>
      </div>
      @empty
      <div class="stat-card"><div class="stat-icon" style="font-size:28px;background:#f0f2f5;">&#x1F31E;</div><div class="stat-body"><h3>N/A</h3><p>No weather data</p></div></div>
      @endforelse
    </div>
    <div class="card" style="margin-top:8px;">
      <h3 style="font-size:14px;font-weight:600;margin-bottom:16px;color:#1a1a2e;">Farming Advisories</h3>
      @forelse($weatherAdvisories ?? [] as $advisory)
      <div class="notif-item">
        <div class="notif-dot" style="background:{{ $advisory->color ?? '#fd7e14' }};"></div>
        <div class="notif-body">
          <p><strong style="color:#1a1a2e;">{{ $advisory->location ?? 'N/A' }}:</strong> {{ $advisory->message ?? 'No advisory' }}</p>
          <span>Valid until {{ $advisory->valid_until ? $advisory->valid_until->format('M d, Y') : 'N/A' }}</span>
        </div>
      </div>
      @empty
      <div style="text-align:center;padding:20px;color:#6a7a8a;"><p>No weather advisories available</p></div>
      @endforelse
    </div>
  </div>

  <!-- ===== AI CHAT ===== -->
  <div class="page" id="page-aichat">
    <div class="section-heading">
      <h2><i class="fas fa-robot" style="color:#0d6efd;margin-right:8px;"></i>AI Chat (Vet Bot)</h2>
      <button class="btn btn-outline" onclick="clearChatHistory()"><i class="fas fa-trash"></i> Clear History</button>
    </div>
    <div class="card" style="display:flex;flex-direction:column;height:520px;">
      <div style="flex:1;overflow-y:auto;padding:10px 0;display:flex;flex-direction:column;gap:14px;" id="chatMessages">
        <div style="display:flex;gap:10px;align-items:flex-start;">
          <div style="width:36px;height:36px;background:linear-gradient(135deg,#0d6efd,#0a58ca);border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;"><i class="fas fa-robot" style="color:#fff;font-size:16px;"></i></div>
          <div style="background:#f0f2f5;border:1px solid #e8ecf1;border-radius:0 12px 12px 12px;padding:12px 16px;max-width:75%;font-size:13.5px;color:#1a1a2e;line-height:1.6;">Hello! I am JaguzaAI, your veterinary assistant. I can help you diagnose animal symptoms, recommend treatments, provide disease information, and more. How can I help you today?</div>
        </div>
      </div>
      <div style="display:flex;gap:10px;padding-top:16px;border-top:1px solid #e8ecf1;margin-top:10px;">
        <input class="form-control" type="text" placeholder="Ask JaguzaAI about symptoms, treatments, diseases..." style="flex:1;" id="chatInput" />
        <button class="btn btn-primary" style="padding:10px 20px;" onclick="sendChatMessage()"><i class="fas fa-paper-plane"></i></button>
      </div>
    </div>
  </div>

  <!-- ===== DECISION SUPPORT ===== -->
  <div class="page" id="page-decision">
    <div class="section-heading">
      <h2><i class="fas fa-brain" style="color:#0d6efd;margin-right:8px;"></i>Decision Support</h2>
      <button class="btn btn-primary" onclick="openAddDecisionModal()">+ Add Article</button>
    </div>
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-icon" style="background:#e8f5e9;color:#2e7d32;"><i class="fas fa-lightbulb"></i></div><div class="stat-body"><h3>{{ number_format(count($decisionSupport)) }}</h3><p>AI Recommendations</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#e3f2fd;color:#0d47a1;"><i class="fas fa-check-circle"></i></div><div class="stat-body"><h3>94%</h3><p>Accuracy Rate</p></div></div>
      <div class="stat-card"><div class="stat-icon" style="background:#fff3e0;color:#e65100;"><i class="fas fa-clock"></i></div><div class="stat-body"><h3>1.2s</h3><p>Avg Response Time</p></div></div>
    </div>
    <div class="card">
      @forelse($decisionSupport as $article)
      <div class="notif-item">
        <div class="notif-dot" style="background:{{ $article->is_featured ? '#2e7d32' : '#0d6efd' }};"></div>
        <div class="notif-body">
          <p><strong style="color:#1a1a2e;">{{ $article->title }}</strong></p>
          <p style="font-size:13px;color:#4a5a6a;margin-top:2px;">{{ Str::limit($article->summary ?? $article->content ?? '', 150) }}</p>
          <span style="display:flex;gap:12px;margin-top:6px;">
            <span><i class="fas fa-tag"></i> {{ ucfirst($article->category ?? 'General') }}</span>
            <span><i class="fas fa-star"></i> {{ $article->difficulty_level ?? 'Beginner' }}</span>
            <span><i class="fas fa-eye"></i> {{ number_format($article->views_count ?? 0) }} views</span>
          </span>
        </div>
      </div>
      @empty
      <div style="text-align:center;padding:40px;color:#6a7a8a;"><p>No decision support articles available.</p></div>
      @endforelse
    </div>
  </div>

  <!-- ===== SETTINGS ===== -->
  <div class="page" id="page-settings">
    <div class="section-heading">
      <h2><i class="fas fa-cog" style="color:#2e7d32;margin-right:8px;"></i>Settings</h2>
      <button class="btn btn-primary" onclick="saveSettings()">Save Changes</button>
    </div>
    <div class="card">
      <h3 style="font-size:14px;font-weight:600;margin-bottom:20px;color:#1a1a2e;">General Settings</h3>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:18px;">
        <div class="form-group"><label>App Name</label><input class="form-control" id="setting_app_name" value="{{ $settings['app_name'] ?? 'Jaguza Livestock Management' }}" /></div>
        <div class="form-group"><label>Admin Email</label><input class="form-control" id="setting_admin_email" value="{{ $settings['admin_email'] ?? 'admin@jaguzalivestock.com' }}" /></div>
        <div class="form-group"><label>Country</label><input class="form-control" id="setting_country" value="{{ $settings['country'] ?? 'Uganda' }}" /></div>
        <div class="form-group"><label>Currency</label><input class="form-control" id="setting_currency" value="{{ $settings['currency'] ?? 'UGX' }}" /></div>
        <div class="form-group"><label>App Version</label><input class="form-control" id="setting_version" value="{{ $settings['app_version'] ?? '2.0.0' }}" readonly /></div>
        <div class="form-group"><label>Backend URL</label><input class="form-control" id="setting_backend_url" value="{{ $settings['backend_url'] ?? 'https://api.jaguzalivestock.com' }}" /></div>
      </div>
    </div>
  </div>

</div>

<!-- ============================================ -->
<!-- ===== MODALS ===== -->
<!-- ============================================ -->

<!-- ===== USER MODAL ===== -->
<div class="modal-overlay" id="userModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="userModalTitle">Add New User</h3>
            <button class="modal-close" onclick="closeModal('userModal')">&times;</button>
        </div>
        <form id="userForm" onsubmit="event.preventDefault(); saveUser();">
            <input type="hidden" id="userId">
            
            <div class="form-group">
                <label>Full Name <span class="required">*</span></label>
                <input type="text" id="user_name" class="form-control" placeholder="John Doe" required>
            </div>
            
            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" id="user_email" class="form-control" placeholder="john@example.com" required>
            </div>
            
            <div class="form-group">
                <label>Role <span class="required">*</span></label>
                <select id="user_role" class="form-control" required onchange="toggleFarmFields()">
                    <option value="admin">Administrator</option>
                    <option value="farmer" selected>Farmer</option>
                    <option value="vet">Veterinary Doctor</option>
                    <option value="manager">Manager</option>
                    <option value="staff">Staff</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" id="user_phone" class="form-control" placeholder="+256 700 000 000">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label id="passwordLabel">Password <span class="required">*</span></label>
                    <input type="password" id="user_password" class="form-control" placeholder="Min 8 characters" required>
                </div>
                <div class="form-group">
                    <label id="confirmPasswordLabel">Confirm Password <span class="required">*</span></label>
                    <input type="password" id="user_password_confirm" class="form-control" placeholder="Confirm password" required>
                </div>
            </div>
            
            <!-- Farm fields - only visible when role is farmer -->
            <div id="farmFields" style="display: block;">
                <div class="form-row">
                    <div class="form-group">
                        <label>Farm Name</label>
                        <input type="text" id="user_farm_name" class="form-control" placeholder="Enter farm name">
                    </div>
                    <div class="form-group">
                        <label>Farm Location</label>
                        <input type="text" id="user_farm_location" class="form-control" placeholder="Enter farm location">
                    </div>
                </div>
            </div>
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="userSubmitBtn">Save User</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('userModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== DOCTOR MODAL ===== -->
<div class="modal-overlay" id="doctorModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="doctorModalTitle">Add New Doctor</h3>
            <button class="modal-close" onclick="closeModal('doctorModal')">&times;</button>
        </div>
        <form id="doctorForm" onsubmit="event.preventDefault(); saveDoctor();">
            <input type="hidden" id="doctorId">
            
            <div class="form-group">
                <label>Doctor Name <span class="required">*</span></label>
                <input type="text" id="doctor_name" class="form-control" placeholder="Dr. John Doe" required>
            </div>
            
            <div class="form-group">
                <label>Email <span class="required">*</span></label>
                <input type="email" id="doctor_email" class="form-control" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Specialization <span class="required">*</span></label>
                    <input type="text" id="doctor_specialization" class="form-control" placeholder="Bovine Medicine" required>
                </div>
                <div class="form-group">
                    <label>License Number <span class="required">*</span></label>
                    <input type="text" id="doctor_license" class="form-control" placeholder="LIC-1234" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Location <span class="required">*</span></label>
                    <input type="text" id="doctor_location" class="form-control" placeholder="Kampala, Uganda" required>
                </div>
                <div class="form-group">
                    <label>Phone <span class="required">*</span></label>
                    <input type="text" id="doctor_phone" class="form-control" placeholder="+256 700 000 000" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Years of Experience</label>
                    <input type="number" id="doctor_experience" class="form-control" placeholder="5" min="0">
                </div>
                <div class="form-group">
                    <label>Consultation Fee</label>
                    <input type="number" id="doctor_fee" class="form-control" placeholder="50000" min="0">
                </div>
            </div>
            
            <div class="form-group">
                <label>Bio</label>
                <textarea id="doctor_bio" class="form-control" rows="3" placeholder="Brief description about the doctor..."></textarea>
            </div>
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="doctorSubmitBtn">Save Doctor</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('doctorModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== ANIMAL MODAL ===== -->
<div class="modal-overlay" id="animalModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="animalModalTitle">Add New Animal</h3>
            <button class="modal-close" onclick="closeModal('animalModal')">&times;</button>
        </div>
        <form id="animalForm" onsubmit="event.preventDefault(); saveAnimal();">
            <input type="hidden" id="animalId">
            
            <div class="form-group">
                <label>Identification Number <span class="required">*</span></label>
                <input type="text" id="animal_identification" class="form-control" placeholder="AN-0001" required>
            </div>
            
            <div class="form-group">
                <label>Name</label>
                <input type="text" id="animal_name" class="form-control" placeholder="Animal name">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Type <span class="required">*</span></label>
                    <select id="animal_type" class="form-control" required>
                        <option value="cattle">Cattle</option>
                        <option value="goat">Goat</option>
                        <option value="sheep">Sheep</option>
                        <option value="pig">Pig</option>
                        <option value="poultry">Poultry</option>
                        <option value="rabbit">Rabbit</option>
                        <option value="horse">Horse</option>
                        <option value="other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Breed <span class="required">*</span></label>
                    <input type="text" id="animal_breed" class="form-control" placeholder="Friesian" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Gender <span class="required">*</span></label>
                    <select id="animal_gender" class="form-control" required>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Age (months) <span class="required">*</span></label>
                    <input type="number" id="animal_age" class="form-control" placeholder="24" min="0" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Weight (kg)</label>
                    <input type="number" id="animal_weight" class="form-control" placeholder="250" min="0" step="0.1">
                </div>
                <div class="form-group">
                    <label>Health Status <span class="required">*</span></label>
                    <select id="animal_health" class="form-control" required>
                        <option value="healthy">Healthy</option>
                        <option value="sick">Sick</option>
                        <option value="treatment">Under Treatment</option>
                        <option value="quarantine">Quarantine</option>
                        <option value="critical">Critical</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>Farm <span class="required">*</span></label>
                <select id="animal_farm" class="form-control" required>
                    <option value="">Select Farm</option>
                    @foreach($farms ?? [] as $farm)
                    <option value="{{ $farm->id }}">{{ $farm->name }}</option>
                    @endforeach
                </select>
            </div>
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save Animal</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('animalModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== REPORT MODAL ===== -->
<div class="modal-overlay" id="reportModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="reportModalTitle">Add New Report</h3>
            <button class="modal-close" onclick="closeModal('reportModal')">&times;</button>
        </div>
        <form id="reportForm" onsubmit="event.preventDefault(); saveReport();">
            <input type="hidden" id="reportId">
            
            <div class="form-group">
                <label>Animal <span class="required">*</span></label>
                <select id="report_animal" class="form-control" required>
                    <option value="">Select Animal</option>
                    @foreach($animals ?? [] as $animal)
                    <option value="{{ $animal->id }}">{{ $animal->name ?? $animal->identification_number }}</option>
                    @endforeach
                </select>
            </div>
            
            <div class="form-group">
                <label>Symptoms <span class="required">*</span></label>
                <textarea id="report_symptoms" class="form-control" rows="3" placeholder="Describe the symptoms..." required></textarea>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>Status <span class="required">*</span></label>
                    <select id="report_status" class="form-control" required>
                        <option value="open">Open</option>
                        <option value="treating">Under Treatment</option>
                        <option value="resolved">Resolved</option>
                        <option value="critical">Critical</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Doctor</label>
                    <select id="report_doctor" class="form-control">
                        <option value="">Unassigned</option>
                        @foreach($doctors ?? [] as $doctor)
                        <option value="{{ $doctor->id }}">Dr. {{ $doctor->user->name ?? '' }}</option>
                        @endforeach
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>Diagnosis</label>
                <textarea id="report_diagnosis" class="form-control" rows="2" placeholder="Initial diagnosis..."></textarea>
            </div>
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Save Report</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('reportModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
// Toggle Farm Fields Based on Role
// ============================================

function toggleFarmFields() {
    const role = document.getElementById('user_role').value;
    const farmFields = document.getElementById('farmFields');
    
    if (role === 'farmer') {
        farmFields.style.display = 'block';
    } else {
        farmFields.style.display = 'none';
        // Clear farm fields when not farmer
        document.getElementById('user_farm_name').value = '';
        document.getElementById('user_farm_location').value = '';
    }
}

// ============================================
// Chart Configuration
// ============================================

Chart.defaults.color = '#4a5a6a';
Chart.defaults.borderColor = '#e8ecf1';
Chart.defaults.font.family = 'Inter';

const chartMonths = @json($months);
const sicknessData = @json($sicknessData);
const userData = @json($userData);
const marketData = @json($marketData);
const livestockLabels = @json($livestockLabels);
const livestockValues = @json($livestockValues);

function renderDashboardCharts() {
    new Chart(document.getElementById('sickChart'), {
        type: 'bar',
        data: {
            labels: chartMonths,
            datasets: [{
                label: 'Reports',
                data: sicknessData,
                backgroundColor: 'rgba(220,53,69,.2)',
                borderColor: '#dc3545',
                borderWidth: 2,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
    
    const colors = ['#43a047','#66bb6a','#ffa726','#ef5350','#42a5f5','#ab47bc','#78909c','#8d6e63'];
    new Chart(document.getElementById('animalChart'), {
        type: 'doughnut',
        data: {
            labels: livestockLabels.map(label => label.charAt(0).toUpperCase() + label.slice(1)),
            datasets: [{
                data: livestockValues,
                backgroundColor: colors.slice(0, livestockLabels.length),
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { legend: { position: 'right' } }
        }
    });
    
    new Chart(document.getElementById('userChart'), {
        type: 'line',
        data: {
            labels: chartMonths,
            datasets: [{
                label: 'New Users',
                data: userData,
                borderColor: '#2e7d32',
                backgroundColor: 'rgba(46,125,50,0.1)',
                borderWidth: 2.5,
                tension: 0.4,
                fill: true,
                pointBackgroundColor: '#2e7d32'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
    
    new Chart(document.getElementById('marketChart'), {
        type: 'bar',
        data: {
            labels: chartMonths,
            datasets: [{
                label: 'Listings',
                data: marketData,
                backgroundColor: 'rgba(253,126,20,.2)',
                borderColor: '#fd7e14',
                borderWidth: 2,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

function renderAnalyticsCharts() {
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    new Chart(document.getElementById('userGrowthChart'), { 
        type:'line', 
        data:{ 
            labels:months, 
            datasets:[{ 
                label:'Users', 
                data:[800,920,1040,1200,1380,1520,1700,1840,1980,2150,2300,2481], 
                borderColor:'#2e7d32', 
                backgroundColor:'rgba(46,125,50,0.08)', 
                borderWidth:2.5, 
                tension:0.4, 
                fill:true 
            }] 
        }, 
        options:{ 
            responsive:true, 
            maintainAspectRatio:true,
            plugins:{legend:{display:false}}, 
            scales:{y:{beginAtZero:false}} 
        } 
    });
    
    new Chart(document.getElementById('diseaseChart'), { 
        type:'pie', 
        data:{ 
            labels:['ECF','FMD','Newcastle','Brucellosis','ASF','Other'], 
            datasets:[{ 
                data:[82,64,58,41,28,74], 
                backgroundColor:['#ef5350','#ffa726','#42a5f5','#ab47bc','#66bb6a','#78909c'], 
                borderWidth:0 
            }] 
        }, 
        options:{ 
            responsive:true, 
            maintainAspectRatio:true,
            plugins:{legend:{position:'right'}} 
        } 
    });
}

// ============================================
// DOCTOR CRUD FUNCTIONS
// ============================================

function resetDoctorForm() {
    document.getElementById('doctorId').value = '';
    document.getElementById('doctor_name').value = '';
    document.getElementById('doctor_email').value = '';
    document.getElementById('doctor_specialization').value = '';
    document.getElementById('doctor_license').value = '';
    document.getElementById('doctor_experience').value = '';
    document.getElementById('doctor_fee').value = '';
    document.getElementById('doctor_location').value = '';
    document.getElementById('doctor_phone').value = '';
    document.getElementById('doctor_bio').value = '';
    document.getElementById('doctorModalTitle').textContent = 'Add New Doctor';
    document.getElementById('doctorSubmitBtn').textContent = 'Save Doctor';
}

function openAddDoctorModal() {
    resetDoctorForm();
    openModal('doctorModal');
}

function editDoctor(id) {
    showToast('Loading doctor data...', 'info');
    
    fetch(`${API_URL}/doctors/${id}`, {
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const doctor = data.data;
            const user = doctor.user;
            
            document.getElementById('doctorId').value = doctor.id;
            document.getElementById('doctor_name').value = user?.name || '';
            document.getElementById('doctor_email').value = user?.email || '';
            document.getElementById('doctor_specialization').value = doctor.specialization || '';
            document.getElementById('doctor_license').value = doctor.license_number || '';
            document.getElementById('doctor_experience').value = doctor.years_of_experience || 0;
            document.getElementById('doctor_fee').value = doctor.consultation_fee || 0;
            document.getElementById('doctor_location').value = doctor.location || '';
            document.getElementById('doctor_phone').value = doctor.phone_number || '';
            document.getElementById('doctor_bio').value = doctor.bio || '';
            
            document.getElementById('doctorModalTitle').textContent = 'Edit Doctor';
            document.getElementById('doctorSubmitBtn').textContent = 'Update Doctor';
            
            openModal('doctorModal');
        } else {
            showToast(data.message || 'Error loading doctor', 'error');
        }
    })
    .catch(error => {
        showToast('Error loading doctor: ' + error.message, 'error');
    });
}

function deleteDoctor(id) {
    if (!confirm('⚠️ Are you sure you want to delete this doctor? This will also delete their user account.')) return;
    
    fetch(`${API_URL}/doctors/${id}`, {
        method: 'DELETE',
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Doctor deleted successfully!');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast(data.message || 'Error deleting doctor', 'error');
        }
    })
    .catch(error => {
        showToast('Error: ' + error.message, 'error');
    });
}

function saveDoctor() {
    const id = document.getElementById('doctorId').value;
    
    // Build data object with correct field names
    const data = {
        name: document.getElementById('doctor_name').value,
        email: document.getElementById('doctor_email').value,
        specialization: document.getElementById('doctor_specialization').value,
        license_number: document.getElementById('doctor_license').value,
        years_of_experience: parseInt(document.getElementById('doctor_experience').value) || 0,
        consultation_fee: parseFloat(document.getElementById('doctor_fee').value) || 0,
        location: document.getElementById('doctor_location').value,
        phone_number: document.getElementById('doctor_phone').value,
        bio: document.getElementById('doctor_bio').value,
    };
    
    const url = id ? `${API_URL}/doctors/${id}` : `${API_URL}/doctors`;
    const method = id ? 'PUT' : 'POST';
    
    const submitBtn = document.getElementById('doctorSubmitBtn');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Saving...';
    
    fetch(url, {
        method: method,
        headers: getHeaders(),
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update Doctor' : 'Save Doctor';
        
        if (data.success) {
            showToast(id ? 'Doctor updated successfully!' : 'Doctor added successfully!');
            closeModal('doctorModal');
            setTimeout(() => location.reload(), 1000);
        } else {
            let errors = '';
            if (data.errors) {
                Object.values(data.errors).forEach(error => {
                    errors += error + '\n';
                });
                showToast(errors, 'error');
            } else {
                showToast(data.message || 'Error saving doctor', 'error');
            }
        }
    })
    .catch(error => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update Doctor' : 'Save Doctor';
        showToast('Network error: ' + error.message, 'error');
    });
}

function toggleDoctorAvailability(id, currentStatus) {
    const action = currentStatus ? 'mark as busy' : 'mark as available';
    if (!confirm(`Are you sure you want to ${action} this doctor?`)) return;
    
    fetch(`${API_URL}/doctors/${id}/availability`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify({ is_available: !currentStatus })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast(data.message);
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast(data.message || 'Error updating availability', 'error');
        }
    })
    .catch(error => {
        showToast('Error: ' + error.message, 'error');
    });
}

// ============================================
// Navigation Functions
// ============================================

function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('collapsed');
    document.getElementById('topbar').classList.toggle('shifted');
    document.getElementById('main-wrap').classList.toggle('shifted');
}

function navigate(pageId, title) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    var page = document.getElementById('page-' + pageId);
    if (page) page.classList.add('active');
    var nav = document.getElementById('nav-' + pageId);
    if (nav) nav.classList.add('active');
    document.getElementById('page-title').textContent = title || pageId.charAt(0).toUpperCase() + pageId.slice(1);
    document.getElementById('main-wrap').scrollTop = 0;
    if (pageId === 'analytics' && !window.analyticsRendered) { 
        renderAnalyticsCharts(); 
        window.analyticsRendered = true; 
    }
}

// ============================================
// API Helpers
// ============================================

const API_URL = '{{ url("/api/v1") }}';
const CSRF_TOKEN = '{{ csrf_token() }}';

function getHeaders() {
    return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-TOKEN': CSRF_TOKEN,
    };
}

function showToast(message, type = 'success') {
    const existing = document.querySelector('.toast');
    if (existing) existing.remove();
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    const icons = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        warning: 'fa-exclamation-triangle',
        info: 'fa-info-circle'
    };
    toast.innerHTML = `<i class="fas ${icons[type] || icons.info}"></i> ${message}`;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100px)';
        toast.style.transition = 'all 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        console.error('Modal not found:', modalId);
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
        const form = document.getElementById(modalId + 'Form');
        if (form) form.reset();
    }
}

// Close modal on overlay click
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.remove('active');
                document.body.style.overflow = '';
            }
        });
    });
});

// ============================================
// USER CRUD FUNCTIONS
// ============================================

function resetUserForm() {
    document.getElementById('userId').value = '';
    document.getElementById('user_name').value = '';
    document.getElementById('user_email').value = '';
    document.getElementById('user_role').value = 'farmer';
    document.getElementById('user_phone').value = '';
    document.getElementById('user_farm_name').value = '';
    document.getElementById('user_farm_location').value = '';
    document.getElementById('user_password').value = '';
    document.getElementById('user_password_confirm').value = '';
    document.getElementById('user_password').required = true;
    document.getElementById('user_password_confirm').required = true;
    document.getElementById('userModalTitle').textContent = 'Add New User';
    document.getElementById('passwordLabel').textContent = 'Password *';
    document.getElementById('confirmPasswordLabel').textContent = 'Confirm Password *';
    document.getElementById('userSubmitBtn').textContent = 'Save User';
    
    // Show farm fields by default (since farmer is default role)
    document.getElementById('farmFields').style.display = 'block';
}

function openAddUserModal() {
    resetUserForm();
    openModal('userModal');
}

function editUser(id) {
    showToast('Loading user data...', 'info');
    
    fetch(`${API_URL}/users/${id}`, {
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const user = data.data;
            document.getElementById('userId').value = user.id;
            document.getElementById('user_name').value = user.name || '';
            document.getElementById('user_email').value = user.email || '';
            document.getElementById('user_role').value = user.role || 'farmer';
            document.getElementById('user_phone').value = user.phone_number || '';
            
            // Set farm fields
            document.getElementById('user_farm_name').value = user.farm_name || '';
            document.getElementById('user_farm_location').value = user.farm_location || '';
            
            // Show/hide farm fields based on role
            toggleFarmFields();
            
            document.getElementById('userModalTitle').textContent = 'Edit User';
            document.getElementById('passwordLabel').textContent = 'New Password (optional)';
            document.getElementById('confirmPasswordLabel').textContent = 'Confirm New Password';
            document.getElementById('user_password').required = false;
            document.getElementById('user_password_confirm').required = false;
            document.getElementById('userSubmitBtn').textContent = 'Update User';
            openModal('userModal');
        } else {
            showToast(data.message || 'Error loading user', 'error');
        }
    })
    .catch(error => {
        showToast('Error loading user: ' + error.message, 'error');
    });
}

function deleteUser(id) {
    if (!confirm('⚠️ Are you sure you want to delete this user?')) return;
    
    fetch(`${API_URL}/users/${id}`, {
        method: 'DELETE',
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('User deleted successfully!');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast(data.message || 'Error deleting user', 'error');
        }
    })
    .catch(error => {
        showToast('Error: ' + error.message, 'error');
    });
}

function saveUser() {
    const id = document.getElementById('userId').value;
    const password = document.getElementById('user_password').value;
    const passwordConfirm = document.getElementById('user_password_confirm').value;
    const role = document.getElementById('user_role').value;
    
    if (password !== passwordConfirm) {
        showToast('Passwords do not match!', 'error');
        return;
    }
    
    const data = {
        name: document.getElementById('user_name').value,
        email: document.getElementById('user_email').value,
        role: role,
        phone_number: document.getElementById('user_phone').value,
    };
    
    // Only include farm fields if role is farmer
    if (role === 'farmer') {
        data.farm_name = document.getElementById('user_farm_name').value || null;
        data.farm_location = document.getElementById('user_farm_location').value || null;
    }
    
    if (password) data.password = password;
    
    const url = id ? `${API_URL}/users/${id}` : `${API_URL}/users`;
    const method = id ? 'PUT' : 'POST';
    
    const submitBtn = document.getElementById('userSubmitBtn');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Saving...';
    
    fetch(url, {
        method: method,
        headers: getHeaders(),
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update User' : 'Save User';
        
        if (data.success) {
            showToast(id ? 'User updated successfully!' : 'User created successfully!');
            closeModal('userModal');
            setTimeout(() => location.reload(), 1000);
        } else {
            let errors = '';
            if (data.errors) {
                Object.values(data.errors).forEach(error => {
                    errors += error + '\n';
                });
                showToast(errors, 'error');
            } else {
                showToast(data.message || 'Error saving user', 'error');
            }
        }
    })
    .catch(error => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update User' : 'Save User';
        showToast('Network error: ' + error.message, 'error');
    });
}

// ============================================
// OTHER MODAL FUNCTIONS
// ============================================

function openAddReportModal() { openModal('reportModal'); }
function openAddDoctorModal() { openModal('doctorModal'); }
function openAddAnimalModal() { openModal('animalModal'); }

function openAddDiseaseModal() { alert('Add Disease functionality coming soon!'); }
function openAddFarmModal() { alert('Add Farm functionality coming soon!'); }
function openAddVideoModal() { alert('Upload Video functionality coming soon!'); }
function openAddAdModal() { alert('Create Ad functionality coming soon!'); }
function openAddGestationModal() { alert('Add Gestation functionality coming soon!'); }
function openAddNotificationModal() { alert('Send Notification functionality coming soon!'); }
function openComposeMessageModal() { alert('Compose Message functionality coming soon!'); }
function openAddVaccinationModal() { alert('Add Vaccination functionality coming soon!'); }
function openAddListingModal() { alert('Add Listing functionality coming soon!'); }
function openAddDecisionModal() { alert('Add Decision Article functionality coming soon!'); }

function refreshWeather() { alert('Refreshing weather data...'); }
function clearChatHistory() { if(confirm('Clear chat history?')) { alert('Cleared'); } }
function sendChatMessage() { 
    const input = document.getElementById('chatInput');
    if(input && input.value.trim()) { alert('Sending: ' + input.value); input.value = ''; }
}
function saveSettings() { alert('Settings saved!'); }
function exportReport() { alert('Exporting report...'); }
function playVideo(id) { alert('Play Video: ' + id); }

// ============================================
// FARM CRUD FUNCTIONS
// ============================================

let selectedFacilities = [];

function addFacility() {
    const select = document.getElementById('facilitySelect');
    const facility = select.value;
    if (facility && !selectedFacilities.includes(facility)) {
        selectedFacilities.push(facility);
        renderFacilities();
    }
    select.value = '';
}

function removeFacility(facility) {
    selectedFacilities = selectedFacilities.filter(f => f !== facility);
    renderFacilities();
}

function renderFacilities() {
    const container = document.getElementById('facilitiesContainer');
    if (selectedFacilities.length === 0) {
        container.innerHTML = '<span style="color:#6a7a8a;font-size:12px;padding:4px 0;">Select facilities from dropdown</span>';
        return;
    }
    container.innerHTML = selectedFacilities.map(f => `
        <span style="background:#e8f5e9;color:#2e7d32;padding:4px 12px;border-radius:16px;font-size:12px;display:inline-flex;align-items:center;gap:6px;">
            ${f}
            <span onclick="removeFacility('${f}')" style="cursor:pointer;color:#dc3545;">&times;</span>
        </span>
    `).join('');
}

function resetFarmForm() {
    document.getElementById('farmId').value = '';
    document.getElementById('farm_name').value = '';
    document.getElementById('farm_owner').value = '';
    document.getElementById('farm_location').value = '';
    document.getElementById('farm_size').value = '';
    document.getElementById('farm_established').value = '';
    document.getElementById('farm_coordinates').value = '';
    document.getElementById('farm_description').value = '';
    selectedFacilities = [];
    renderFacilities();
    document.getElementById('farmModalTitle').textContent = 'Add New Farm';
    document.getElementById('farmSubmitBtn').textContent = 'Save Farm';
}

function openAddFarmModal() {
    resetFarmForm();
    openModal('farmModal');
}

function editFarm(id) {
    showToast('Loading farm data...', 'info');
    
    fetch(`${API_URL}/farms/${id}`, {
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const farm = data.data.farm;
            
            document.getElementById('farmId').value = farm.id;
            document.getElementById('farm_name').value = farm.name || '';
            document.getElementById('farm_owner').value = farm.owner_name || '';
            document.getElementById('farm_location').value = farm.location || '';
            document.getElementById('farm_size').value = farm.size || '';
            document.getElementById('farm_established').value = farm.established_year || '';
            document.getElementById('farm_coordinates').value = farm.coordinates || '';
            document.getElementById('farm_description').value = farm.description || '';
            
            selectedFacilities = farm.facilities || [];
            renderFacilities();
            
            document.getElementById('farmModalTitle').textContent = 'Edit Farm';
            document.getElementById('farmSubmitBtn').textContent = 'Update Farm';
            openModal('farmModal');
        } else {
            showToast(data.message || 'Error loading farm', 'error');
        }
    })
    .catch(error => {
        showToast('Error loading farm: ' + error.message, 'error');
    });
}

function deleteFarm(id) {
    if (!confirm('⚠️ Are you sure you want to delete this farm? This will also remove all associated animals.')) return;
    
    fetch(`${API_URL}/farms/${id}`, {
        method: 'DELETE',
        headers: getHeaders()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Farm deleted successfully!');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast(data.message || 'Error deleting farm', 'error');
        }
    })
    .catch(error => {
        showToast('Error: ' + error.message, 'error');
    });
}

function saveFarm() {
    const id = document.getElementById('farmId').value;
    
    const data = {
        farm_name: document.getElementById('farm_name').value,
        owner_name: document.getElementById('farm_owner').value,
        location: document.getElementById('farm_location').value,
        size: document.getElementById('farm_size').value,
        established_year: document.getElementById('farm_established').value,
        coordinates: document.getElementById('farm_coordinates').value,
        description: document.getElementById('farm_description').value,
        facilities: selectedFacilities,
    };
    
    const url = id ? `${API_URL}/farms/${id}` : `${API_URL}/farms`;
    const method = id ? 'PUT' : 'POST';
    
    const submitBtn = document.getElementById('farmSubmitBtn');
    submitBtn.disabled = true;
    submitBtn.textContent = 'Saving...';
    
    fetch(url, {
        method: method,
        headers: getHeaders(),
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update Farm' : 'Save Farm';
        
        if (data.success) {
            showToast(id ? 'Farm updated successfully!' : 'Farm created successfully!');
            closeModal('farmModal');
            setTimeout(() => location.reload(), 1000);
        } else {
            let errors = '';
            if (data.errors) {
                Object.values(data.errors).forEach(error => {
                    errors += error + '\n';
                });
                showToast(errors, 'error');
            } else {
                showToast(data.message || 'Error saving farm', 'error');
            }
        }
    })
    .catch(error => {
        submitBtn.disabled = false;
        submitBtn.textContent = id ? 'Update Farm' : 'Save Farm';
        showToast('Network error: ' + error.message, 'error');
    });
}

// ============================================
// Initialization
// ============================================

window.addEventListener('DOMContentLoaded', function() {
    renderDashboardCharts();
    toggleFarmFields(); // Initialize farm fields toggle
    
    // Global search
    document.getElementById('globalSearch').addEventListener('keyup', function(e) {
        if(e.key === 'Enter' && this.value.length > 2) {
            alert('Searching for: ' + this.value);
        }
    });
});
</script>
</body>
</html>