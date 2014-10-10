<?php
/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 8/10/13
 * Time: 2:39 AM
 * This is not to be removed.
 */
$con = mysql_connect("localhost","mdhschedule","yzupe2ujy");
if (!$con)
{
    die('Could not connect: ' . mysql_error());
}
mysql_select_db("zadmin_mdhschedule", $con);
mysql_set_charset('utf8',$con);
//"localhost", "zadmin_mdhschedule", "mdhschedule", "yzupe2ujy"


//$xml = simplexml_load_file('data/maps.xml');

//$matches = $xml->xpath('//bodies//body');
//die();
//foreach ($matches as $b) {
//    $name = $b['name'];
//    $newb = $b->xpath('fixtures');
//    foreach ($newb as $a) {
//        $newe = $a->xpath('fixture');
//        foreach ($newe as $e) {
//            $insertroom = mysql_query("INSERT INTO RoomLocations (MapID) VALUES ('$name')");
//            $roomlocationid = mysql_insert_id();
//            $fixturex = array();
//            $fixturey = array();
//            $newd = $e->xpath('polygons');
//            foreach ($newd as $d) {
//                $newa = $d->xpath('polygon');
//                foreach ($newa as $c) {
//                    $insertpolygon = mysql_query("INSERT INTO RoomPolygons (RoomLocationID) VALUES ('$roomlocationid')");
//                    $polygonid = mysql_insert_id();
//                    //echo $c . '<br/>';
//                    $points = explode(", ", $c);
//                    $cur=0;
//                    $xid = 0;
//                    foreach ($points as $p) {
//                        if ($cur == 0) {
//                            $insertx = mysql_query("INSERT INTO RoomVertexes (PolygonID, X) VALUES ('$polygonid', '".trim($p)."')");
//                            $xid = mysql_insert_id();
//                            $fixturex[] = trim($p);
//                            $cur = 1;
//                        } else {
//                            $inserty = mysql_query("UPDATE RoomVertexes SET Y = '".trim($p)."' WHERE VertexID = '$xid'")or die(mysql_error());
//                            $fixturey[] = trim($p);
//                            $cur = 0;
//                        }
//                    }
//                }
//            }
//            $sumx = 0;
//            $sumy = 0;
//            $count = 0;
//            foreach ($fixturex as $fx) {
//                $sumx = $sumx + $fx;
//                $count++;
//            }
//            foreach ($fixturey as $fy) {
//                $sumy = $sumy + $fy;
//            }
//            $centerx = $sumx/$count;
//            $centery = $sumy/$count;
//            mysql_query("UPDATE RoomLocations SET CenterX = '$centerx', CenterY = '$centery' WHERE id = '$roomlocationid'");
//        }
//    }
//}