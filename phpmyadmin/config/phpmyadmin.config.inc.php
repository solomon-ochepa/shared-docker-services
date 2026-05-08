<?php

/**
 * phpMyAdmin configuration for multiple database servers
 * This configuration prevents session conflicts when accessing multiple MySQL servers
 */

/* Configure session storage to use files instead of database to avoid conflicts */
$cfg['SessionSavePath'] = '/tmp/phpmyadmin_sessions';

/* Server configuration */
$i = 0;

/* Auth MySQL Server */
$i++;
$cfg['Servers'][$i]['host'] = 'auth-mysql';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
$cfg['Servers'][$i]['verbose'] = 'Auth';
$cfg['Servers'][$i]['pmadb'] = ''; // Disable phpMyAdmin configuration storage for this server
$cfg['Servers'][$i]['bookmarktable'] = false;
$cfg['Servers'][$i]['relation'] = false;
$cfg['Servers'][$i]['table_info'] = false;
$cfg['Servers'][$i]['table_coords'] = false;
$cfg['Servers'][$i]['pdf_pages'] = false;
$cfg['Servers'][$i]['column_info'] = false;
$cfg['Servers'][$i]['history'] = false;
$cfg['Servers'][$i]['tracking'] = false;
$cfg['Servers'][$i]['designer_coords'] = false;
$cfg['Servers'][$i]['userconfig'] = false;
$cfg['Servers'][$i]['recent'] = false;
$cfg['Servers'][$i]['favorite'] = false;
$cfg['Servers'][$i]['users'] = false;
$cfg['Servers'][$i]['usergroups'] = false;
$cfg['Servers'][$i]['navigationhiding'] = false;
$cfg['Servers'][$i]['savedsearches'] = false;
$cfg['Servers'][$i]['central_columns'] = false;
$cfg['Servers'][$i]['designer_settings'] = false;
$cfg['Servers'][$i]['export_templates'] = false;

/* MailForce MySQL Server */
$i++;
$cfg['Servers'][$i]['host'] = 'mailforce-mysql';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
$cfg['Servers'][$i]['verbose'] = 'MailForce';
$cfg['Servers'][$i]['pmadb'] = ''; // Disable phpMyAdmin configuration storage for this server
$cfg['Servers'][$i]['bookmarktable'] = false;
$cfg['Servers'][$i]['relation'] = false;
$cfg['Servers'][$i]['table_info'] = false;
$cfg['Servers'][$i]['table_coords'] = false;
$cfg['Servers'][$i]['pdf_pages'] = false;
$cfg['Servers'][$i]['column_info'] = false;
$cfg['Servers'][$i]['history'] = false;
$cfg['Servers'][$i]['tracking'] = false;
$cfg['Servers'][$i]['designer_coords'] = false;
$cfg['Servers'][$i]['userconfig'] = false;
$cfg['Servers'][$i]['recent'] = false;
$cfg['Servers'][$i]['favorite'] = false;
$cfg['Servers'][$i]['users'] = false;
$cfg['Servers'][$i]['usergroups'] = false;
$cfg['Servers'][$i]['navigationhiding'] = false;
$cfg['Servers'][$i]['savedsearches'] = false;
$cfg['Servers'][$i]['central_columns'] = false;
$cfg['Servers'][$i]['designer_settings'] = false;
$cfg['Servers'][$i]['export_templates'] = false;

/* General settings */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['TempDir'] = '/tmp';

/* Override upload limit */
$cfg['ExecTimeLimit'] = 600;
$cfg['MemoryLimit'] = '512M';

/* Prevent automatic database selection errors */
$cfg['NavigationTreeEnableGrouping'] = false;
$cfg['NavigationTreeShowTables'] = true;
$cfg['NavigationTreeShowViews'] = true;
$cfg['NavigationTreeShowFunctions'] = false;
$cfg['NavigationTreeShowProcedures'] = false;
$cfg['NavigationTreeShowEvents'] = false;

/* Use separate cookies for each server to prevent session conflicts */
$cfg['CookieSameSite'] = 'Lax';

/* Security settings */
$cfg['blowfish_secret'] = 'a8b7c6d5e4f3g2h1i0j9k8l7m6n5o4p3'; // 32-char secret for cookie encryption

/* Disable features that might cause cross-server issues */
$cfg['ZeroConf'] = false;
$cfg['PmaNoRelation_DisableWarning'] = true;

/* Include local configuration override if it exists */
$localConfig = '/etc/phpmyadmin/config.local.inc.php';
if (file_exists($localConfig)) {
    include $localConfig;
}
