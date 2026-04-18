<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
include 'db.php';

include 'db.php';

$sql = "SELECT 
            c.category_name,
            SUM(oi.quantity) as total_items_sold
        FROM Order_Items oi
        JOIN Products p ON p.product_id = oi.product_id
        JOIN Categories c ON p.category_id = c.category_id
        GROUP BY c.category_name";

$result = $conn->query($sql);

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>