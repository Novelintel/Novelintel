<?php
if (isset($_POST['message'])) {
    $message = trim($_POST['message']);

    function getUserIP() {
        if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
            return $_SERVER['HTTP_CF_CONNECTING_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            return explode(',', $_SERVER['HTTP_X_FORWARDED_FOR'])[0];
        } elseif (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            return $_SERVER['HTTP_CLIENT_IP'];
        } else {
            return $_SERVER['REMOTE_ADDR'];
        }
    }

    $ip = getUserIP();
    if ($ip === '127.0.0.1') {
        $ip = 'Localhost';
    }

    $baseDir  = __DIR__ . "/../../Data";
    $userDir  = $baseDir . "/" . $ip . "/Info";
    $filePath = $userDir . "/messages.txt";

    if (!is_dir($userDir)) {
        mkdir($userDir, 0777, true);
    }

    $logEntry = "[" . date("Y-m-d H:i:s") . "] " . $message . PHP_EOL;

    file_put_contents($filePath, $logEntry, FILE_APPEND | LOCK_EX);
}
?>

