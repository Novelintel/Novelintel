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

$baseDir  = __DIR__ . "/../../Data";
$userDir  = $baseDir . "/" . $ip . "/Uploads";

if (!is_dir($userDir)) {
    mkdir($userDir, 0777, true);
}

if (isset($_FILES['file']) && $_FILES['file']['error'] === UPLOAD_ERR_OK) {
    $tmpName   = $_FILES['file']['tmp_name'];
    $origName  = basename($_FILES['file']['name']);
    $extension = pathinfo($origName, PATHINFO_EXTENSION);

    $timeStamp = date("Ymd_His");
    $fileName  = $timeStamp . ($extension ? "." . $extension : "");

    $targetPath = $userDir . "/" . $fileName;

    if (move_uploaded_file($tmpName, $targetPath)) {
        echo "File uploaded successfully: " . htmlspecialchars($fileName);
    } else {
        echo "Error saving the file.";
    }
} else {
    echo "No file uploaded or upload error.";
}

?>

