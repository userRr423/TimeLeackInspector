<?php


class Route
{

    public static $validRoutes = array();

    private static $notFound = 0;
    private static $url = '';

    public static function set($route, $function)
    {
        self::$validRoutes[] = $route;
        //print_r(self::$validRoutes);
        //$function->__invoke();
        //echo $_GET['url'];

        //echo "router " . $_GET['url'];

        self::$url = $_GET['url'];
        if ($_GET['url'] == $route) {
            $function->__invoke();
        } 
    }

    public static function getRoutes() {
        return self::$validRoutes;
    }

    public static function getUrl() {
        return self::$url;
    }
}
