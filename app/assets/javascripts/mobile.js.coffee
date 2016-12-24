$ ->
  do_not_download_app = Cookies.get('do-not-download-app') ? false;
  if !do_not_download_app && (isMobile.android.device || isMobile.apple.device)
    if confirm "Do you want to download Bicimapa free app?"
      window.location = "https://play.google.com/store/apps/details?id=fr.ylecuyer.colazo" if isMobile.android.device
      window.location = "https://itunes.apple.com/app/bicimapa/id851915700" if isMobile.apple.device
      Cookies.set('do-not-download-app', true, { expires: 30*3 });
    else
      Cookies.set('do-not-download-app', true, { expires: 30 });

    
