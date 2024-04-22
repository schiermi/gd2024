<?php
/*
 * based on https://github.com/mdn/dom-examples/blob/main/server-sent-events/sse.php
 * Creative Commons Zero v1.0 Universal <https://github.com/mdn/dom-examples/blob/main/LICENSE>
 */

date_default_timezone_set("UTC");
header("X-Accel-Buffering: no");
header("Cache-Control: no-cache");

$db = new SQLite3("db.sqlite3");
$db->exec('
  CREATE TABLE IF NOT EXISTS "visits" (
    "id"	INTEGER NOT NULL UNIQUE,
    "difference" INTEGER DEFAULT 1,
    "time" INTEGER,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
');

if ($_REQUEST["action"] == "increment") {
    $db->exec(
        'INSERT INTO visits (difference, time) VALUES (1, unixepoch("now"))'
    );
}

if ($_REQUEST["action"] == "decrement") {
    $db->exec(
        'INSERT INTO visits (difference, time) VALUES (-1, unixepoch("now"))'
    );
}


$lastsum = $db->querySingle("SELECT SUM(difference) FROM visits;");

if ($_REQUEST["action"] != "events") {
    header("Content-Type: text/plain");
    print "$lastsum\n";
} else {
    header("Content-Type: text/event-stream");
    $lastsum = NULL;
    while (1) {
        $curDate = date(DATE_ISO8601);
        $sum = $db->querySingle("SELECT SUM(difference) FROM visits;");
        if ($sum != $lastsum) {

            print "event: counter\n";
            print "data: " . json_encode(["time" => $curDate, "sum" => $sum]) . "\n\n";
            $lastsum = $sum;

            while (ob_get_level() > 0) {
                ob_end_flush();
            }
            flush();
        }

        if (connection_aborted()) {
            break;
        }
        sleep(1);
    }
}

$db->close();
?>
