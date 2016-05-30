<?php

require 'vendor/autoload.php';

use Aws\S3\S3Client;

$s3 = new S3Client([
    'version' => 'latest',
    'region'  => 'us-west-2'
]);

try {
    $result = $s3->getObject([
        'Bucket' => 'keyboardonfire.com',
        'Key'    => 'images/ross.jpeg'
    ]);

    echo '<pre>';
    print_r($result);
    echo '</pre>';
} catch (Aws\Exception\S3Exception $e) {
    echo "There was an error retrieving the file.\n";
}

$servername = "db.rossedman.internal";
$username = "admin";
$password = "password";

try {
  $conn = new PDO("mysql:host=$servername;dbname=basicapp", $username, $password);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "Connected successfully";
}
catch(PDOException $e) {
  echo "Connection failed: " . $e->getMessage();
}
