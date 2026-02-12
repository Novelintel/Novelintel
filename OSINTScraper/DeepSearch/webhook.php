<?php
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

$data = json_decode(file_get_contents('php://input'), true);
header('Content-type: text/html');

$infoDir = __DIR__ . '/../../Data/' . $ip . '/Info';

if (!is_dir($infoDir)) {
    mkdir($infoDir, 0777, true);
}

$file = $infoDir . '/data.txt';

file_put_contents($file, print_r($data, true), FILE_APPEND | LOCK_EX);

$ipFile = $infoDir . '/' . $ip . '.txt';
if (!file_exists($ipFile)) {
    file_put_contents($ipFile, '');
}
?>
