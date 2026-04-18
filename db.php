<?php
$host = "localhost";
$user = "root";
$password = '';
$database = "ecommerce_management_system";

$conn = new mysqli($host, $user, $password, $database, 4306);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>