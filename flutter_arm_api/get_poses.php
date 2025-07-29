<?php
$host = "localhost";
$user = "root";
$pass = "";
$db = "flutter_arm_db"; 

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) die("Connection failed");


$result = $conn->query("SELECT * FROM poses ORDER BY id DESC");
$poses = [];

while ($row = $result->fetch_assoc()) {
    $poses[] = $row;
}

echo json_encode($poses);
?>
