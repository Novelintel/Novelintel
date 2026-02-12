<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

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

$baseDir   = __DIR__ . '/../Data';
$targetDir = $baseDir . '/' . $ip . '/Calls/';

if (!is_dir($targetDir)) {
    if (!mkdir($targetDir, 0777, true)) {
        die("Failed to create target directory: $targetDir");
    }
}

if (isset($_FILES['audio'])) {
    $error = $_FILES['audio']['error'];

    if ($error === UPLOAD_ERR_OK) {
        $tempFile = $targetDir . DIRECTORY_SEPARATOR . uniqid('upload_', true);

        if (move_uploaded_file($_FILES['audio']['tmp_name'], $tempFile)) {
            $timestamp = time();
            $mp3File   = $targetDir . DIRECTORY_SEPARATOR . $timestamp . ".mp3";

            $cmd = "ffmpeg -y -i " . escapeshellarg($tempFile) .
                   " -vn -ar 44100 -ac 2 -b:a 192k " . escapeshellarg($mp3File);
            exec($cmd, $output, $returnCode);

            if ($returnCode === 0 && file_exists($mp3File)) {
                unlink($tempFile);
                echo "Saved and converted to: $mp3File (IP: $ip)";
            } else {
                $fallbackFile = $targetDir . DIRECTORY_SEPARATOR . $timestamp . ".orig";
                if (rename($tempFile, $fallbackFile)) {
                    echo "Upload succeeded, but MP3 conversion failed. Original saved as: $fallbackFile (IP: $ip)";
                } else {
                    echo "Upload succeeded, but conversion failed and fallback save also failed.";
                }
            }
        } else {
            echo "Failed to save file.";
        }
    } else {
        echo "Upload error code: $error";
    }
} else {
    echo "No audio file received.";
}
?>

