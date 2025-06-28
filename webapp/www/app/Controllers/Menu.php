<?php

class Menu extends Controller
{
    public static $arrlist = array();
    public static function EmployeesList($divClass) {
        //print_r(self::query("SELECT * FROM `user`"));

        foreach(self::query("SELECT * FROM `employees`") as $row)
        {
            self::$arrlist[] = $row['access_code'];
            $name = $row['name'];
            $surname = $row['surname'];
            $middle_name = $row['middle_name'];
            echo "<div onclick=location.href='./employee?name=$name&surname=$surname&middle_name=$middle_name'; class=$divClass>" 
            . $row['surname'] . " " . $row['name'] . "</div>";
        }
    }



}