<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$host = "localhost";
$user = "root";
$pass = "";
$db = "flutter_arm_db";

$conn = new mysqli($host, $user, $pass, $db);


if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode(["message" => "Only POST request allowed."]);
    exit;
}


$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['id'])) {
    echo json_encode(["message" => "ID is required."]);
    exit;
}

$id = $data['id'];

$sql = "DELETE FROM poses WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["message" => "Pose deleted successfully."]);
} else {
    echo json_encode(["message" => "Failed to delete pose."]);
}

$conn->close();
?>
