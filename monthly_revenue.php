<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
include 'db.php';


$sql = "SELECT 
            DATE_FORMAT(o.order_date, '%Y-%m') AS month,
            SUM(oi.quantity * oi.unit_price) AS revenue
        FROM Orders o
        JOIN Order_Items oi ON o.order_id = oi.order_id
        GROUP BY month
        ORDER BY month";

$result = $conn->query($sql);

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>