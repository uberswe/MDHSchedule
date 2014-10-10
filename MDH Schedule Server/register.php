<?php
include_once 'settings.php';
if (!$COMMON->isServerRequest($POST, $FETCH, $echoVal)) {
include_once 'header.php';
    ?>
        <div class="body">

                <div class="searchform">
                    <form method="post" action="index.php">
                        <ul>
                            <li>
                                Student Email <input type="text" name="email">
                            </li>
                            <li>
                                Password <input type="text" name="password">
                            </li>
                            <li>
                                <p>Please <b>do not</b> use the same password as you do on the mdh website or email.</p>
                            </li>
                            <li>
                                <input type="submit" value="Register">
                            </li>
                        </ul>
                    </form>
                </div>
        </div>
<?php
} else {
    echo $echoVal;
}
include_once 'footer.php';
?>