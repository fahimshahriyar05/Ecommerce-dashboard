<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
include 'db.php';

include 'db.php';

$sql = "SELECT 
            c.full_name,
            COUNT(o.order_id) as total_orders
        FROM Customers c
        JOIN Orders o ON c.customer_id = o.customer_id
        GROUP BY c.full_name
        ORDER BY total_orders DESC
        LIMIT 5";

$result = $conn->query($sql);

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>