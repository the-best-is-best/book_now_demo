<?php
require_once('../controller/db.php');
require_once('../models/response.php');

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


if ($_SERVER['REQUEST_METHOD']  !== 'PUT') {
    $response = new Response();
    $response->setHttpStatusCode(405);
    $response->setSuccess(false);
    $response->addMessage('Request method not allowed');
    $response->send();
    exit;
}


if ($_SERVER['CONTENT_TYPE'] !== 'application/json') {
    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);
    $response->addMessage('Content Type header not json');
    $response->send();
    exit;
}

$rowPostData = file_get_contents('php://input');

if (!$jsonData = json_decode($rowPostData)) {

    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);
    $response->addMessage('Request body is not valid json');
    $response->send();
    exit;
}

if (
    !isset($jsonData->id) || !isset($jsonData->numbers_of_bed)
    || !isset($jsonData->bunk_bed)
) {

    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    (!isset($jsonData->id) ?  $response->addMessage("id not supplied") : false);
    (!isset($jsonData->numbers_of_bed) ?  $response->addMessage("number of bed not supplied") : false);
    (!isset($jsonData->bunk_bed) ?  $response->addMessage("number of bunk  bed not supplied") : false);

    $response->send();
    exit;
}

$id = $jsonData->id;
$numbers_of_bed = $jsonData->numbers_of_bed;
$bunk_bed = $jsonData->bunk_bed;


try {

    $query = $writeDB->prepare('UPDATE rooms SET numbers_of_bed = :numbers_of_bed , bunk_bed=:bunk_bed WHERE id = :id ');

    $query->bindParam(':id', $id, PDO::PARAM_STR);
  
    $query->bindParam(':numbers_of_bed', $numbers_of_bed, PDO::PARAM_STR);
    $query->bindParam(':bunk_bed', $bunk_bed, PDO::PARAM_STR);


    $query->execute();

    $rowCount = $query->rowCount();
    if ($rowCount === 0) {
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('There was an issue update rooms - please try again');
        $response->send();
        exit;
    }



    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->addMessage('Room updated');
    $response->send();
    exit;
} catch (PDOException $ex) {
    error_log("Database query error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('There was an issue update rooms - please try again' . $ex);
    $response->send();
    exit;
}
