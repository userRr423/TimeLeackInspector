<?php

class Model
{
    public static $host = "172.16.1.6";
    public static $dbName = "tli";
    public static $userName = "tli";
    public static $password = "tli";

    private static function con()
    {
        $pdo = new PDO("mysql:host=".self::$host.";dbname=".self::$dbName.";charset=utf8", self::$userName, self::$password);
        $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    }

    public static function query($query, $params = array())
    {
        $stmt = self::con()->prepare($query);
        $stmt->execute($params);
        $data = $stmt->fetchAll();
        return $data;
    }

    public static function fetch_assoc($query, $params = array()) {
        $stmt = self::con()->prepare($query);
        $stmt->execute($params);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result;
    }

}
