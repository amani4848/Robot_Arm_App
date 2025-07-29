<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");

$host = 'localhost';
$user = 'root';
$pass = ''; 
$db = 'flutter_arm_db'; 

$conn = new mysqli($host, $user, $pass, $db);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['error' => 'Only POST request allowed.']);
    exit();
}


$data = json_decode(file_get_contents('php://input'), true);


if (!isset($data['motor1'], $data['motor2'], $data['motor3'], $data['motor4'])) {
    echo json_encode(['error' => 'Missing data.']);
    exit();
}

$motor1 = $data['motor1'];
$motor2 = $data['motor2'];
$motor3 = $data['motor3'];
$motor4 = $data['motor4'];


$sql = "INSERT INTO poses (motor1, motor2, motor3, motor4) VALUES ('$motor1', '$motor2', '$motor3', '$motor4')";

if ($conn->query($sql)) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => $conn->error]);
}

$conn->close();
?>
