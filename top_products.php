<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');


include 'db.php';

$sql = "SELECT 
            p.product_name,
            SUM(oi.quantity) as total_sold
        FROM Order_Items oi
        JOIN Products p ON p.product_id = oi.product_id
        GROUP BY p.product_name
        ORDER BY total_sold DESC
        LIMIT 5";

$result = $conn->query($sql);

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>