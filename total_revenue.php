
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
include 'db.php';





$sql = "SELECT SUM(oi.quantity * oi.unit_price) as total_revenue
        FROM Order_Items oi";

$result = $conn->query($sql);
$data = $result->fetch_assoc();

echo json_encode($data);
?>