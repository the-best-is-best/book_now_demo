<?php
require_once('../controller/db.php');
require_once('../models/response.php');

try {
    $readDB = DB::connectReadDB();
} catch (PDOException $ex) {
    error_log("connection Error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('Database connection error');
    $response->send();
    exit;
}
try {
    $writeDB = DB::connectionWriteDB();
} catch (PDOException $ex) {
    error_log("connection Error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('Database connection error');
    $response->send();
    exit;
}

if ($_SERVER['REQUEST_METHOD']  !== 'GET') {
    $response = new Response();
    $response->setHttpStatusCode(405);
    $response->setSuccess(false);
    $response->addMessage('Request method not allowed');
    $response->send();
    exit;
}


try {
    $id = $_GET['id'] ?? null;
    if ($id == null) {
        $haveData = $_GET['haveData'] ?? false;
        if ($haveData == 1) {
            $count = $readDB->prepare("SELECT id FROM houses");
            $count->execute();
            $newRow = count($count->fetchAll()) - $_GET['count'];
            
        }
        $customQuery = $haveData == 1 ? "ORDER BY id DESC LIMIT $newRow" : "";
       
    } else {
        $customQuery = "Where id = $id";
    }
    $query = $readDB->prepare("SELECT * FROM houses $customQuery");
    $query->execute();
    $row = $query->fetchAll();

    $returnData = $row;
    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->setData($returnData);
    $response->send();
    exit;
} catch (PDOException $ex) {
    error_log("Database query error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('There was an issue Get Houses - please try again' . $ex);
    $response->send();
    exit;
}
