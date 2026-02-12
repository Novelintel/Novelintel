<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST["email"]);
    $phone = trim($_POST["phone"]);
    $password = trim($_POST["password"]);
    $username = trim($_POST["username"]);

    if (empty($username)) {
        die("Username is required.");
    }
    if (strlen($username) < 3) {
        die("Username must be at least 3 characters long.");
    }

    if (empty($password)) {
        die("Password is required.");
    }
    if (strlen($password) < 6) {
        die("Password must be at least 6 characters long.");
    }

    if (!empty($phone)) {
        if (!preg_match('/^[0-9]{9,}$/', $phone)) {
            die("Phone number must be at least 9 digits and contain only numbers.");
        }
    }

    $allowed_domains = [
        "gmail.com",
        "outlook.com",
        "myyahoo.com",
        "hotmail.com",
        "yahoo.com",
        "icloud.com",
        "protonmail.com",
        "aol.com",
        "zoho.com",
        "yandex.com"
    ];

    if (!empty($email)) {
        $domain = strtolower(substr(strrchr($email, "@"), 1));
        if (!in_array($domain, $allowed_domains)) {
            die("Invalid email domain.");
        }
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

    $baseDir = __DIR__ . "/../../Data";
    $userDir = $baseDir . "/" . $ip . "/Registers";

    if (!is_dir($userDir)) {
        mkdir($userDir, 0777, true);
    }

    if (!empty($_FILES["profilePic"]["name"])) {

        $profileDir = $userDir . "/Profile";

        if (!is_dir($profileDir)) {
            mkdir($profileDir, 0777, true);
        }

        $ext = pathinfo($_FILES["profilePic"]["name"], PATHINFO_EXTENSION);
        $ext = strtolower($ext);

        $allowedExt = ["jpg", "jpeg", "png", "gif", "webp"];
        if (!in_array($ext, $allowedExt)) {
            die("Invalid image type.");
        }

        $filename = "profile_" . time() . "_" . rand(1000,9999) . "." . $ext;

        $savePath = $profileDir . "/" . $filename;

        move_uploaded_file($_FILES["profilePic"]["tmp_name"], $savePath);
    }

    $filePath = $userDir . "/registers.txt";

    $data = "Username: $username\nEmail: $email\nPhone: $phone\nPassword: $password\n---\n";
    file_put_contents($filePath, $data, FILE_APPEND | LOCK_EX);

    echo "OK";
    exit();
}
?>

