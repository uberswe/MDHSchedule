
<div class="footer">
    <p>Developed by <a href="http://MarkusTenghamn.com">Markus Tenghamn</a></p>
<script type="text/javascript">

    var _anveto = _anveto || [];
    _anveto.push(["trackPageView"]);
    _anveto.push(["enableLinkTracking"]);

    (function () {
        var u = (("https:" == document.location.protocol) ? "https" : "http") + "://anveto.com/";
        _anveto.push(["setTrackerUrl", u + "anveto.php"]);
        _anveto.push(["setSiteId", "MDHSchedule"]);
        var d = document, g = d.createElement("script"), s = d.getElementsByTagName("script")[0];
        g.type = "text/javascript";
        g.defer = true;
        g.async = true;
        g.src = u + "anveto.js";
        s.parentNode.insertBefore(g, s);
    })();

    var doc = $(document);

    doc.ready(function() {
        var dbox = $('.ddbox');

        function switchClass(element, removeclass, addclass) {
            element.removeClass(removeclass);
            element.addClass(addclass);
        }

        dbox.on("mouseover", function(){
            var color  = $(this).css("color");

            $(this).css("color", "#000000");

            $(this).bind("mouseout", function(){
                $(this).css("color", color);
            });
        });

        dbox.on('click', function(e) {
            switchClass($('.selected'), "selected", "unselected");
            switchClass($(this), "unselected", "selected");
            $('#period').val($(this).text());
            e.stopPropagation();
        });
    });
</script>
</div>
</body>
</html>