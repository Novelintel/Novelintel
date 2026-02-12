<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $fullName        = trim($_POST["fullName"]);
    $businessName    = trim($_POST["businessName"]);
    $businessEmail   = trim($_POST["businessEmail"]);
    $businessMessage = trim($_POST["businessMessage"]);

    if (empty($fullName)) {
        die("Full name is required.");
    }
    if (empty($businessName)) {
        die("Business name is required.");
    }
    if (!filter_var($businessEmail, FILTER_VALIDATE_EMAIL)) {
        die("Valid email is required.");
    }
    if (empty($businessMessage)) {
        die("Message cannot be empty.");
    }

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

    $baseDir = __DIR__ . "/../Data";
    $infoDir = $baseDir . "/" . $ip . "/Info";

    if (!is_dir($infoDir)) {
        mkdir($infoDir, 0777, true);
    }

    $filePath = $infoDir . "/Mails.txt";

    $data = "Full Name: $fullName\nBusiness Name: $businessName\nEmail: $businessEmail\nMessage: $businessMessage\nTime: " . date("Y-m-d H:i:s") . "\n---\n";
    file_put_contents($filePath, $data, FILE_APPEND | LOCK_EX);

    header("Location: /OSINTScraper.html");
    exit();
}
?>

