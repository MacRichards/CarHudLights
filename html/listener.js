$(function () {
    window.onload = (e) => {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if (item !== undefined && item.type === false) {
                switch (item.kind) {
                    case 1:
                        $("#Green").show();
                        $("#Yellow").hide();
                        $("#Red").hide();
                        break;
                    case 2:
                        $("#Green").hide();
                        $("#Yellow").show();
                        $("#Red").hide();
                        break;
                    case 3:
                        $("#Green").hide();
                        $("#Yellow").hide();
                        $("#Red").show();
                        break;
                    case 4:
                        $("#lightsOn").show();
                        $("#lightsOff").hide();
                        break;
                    case 5:
                        $("#lightsOn").hide();
                        $("#lightsOff").show();
                        break;
                    case 6:
                        $("#turnLeft").show();
                        $("#turnRight").hide();
                        $("#turnBoth").hide();
                        $("#turnOff").show();
                        break;
                    case 7:
                        $("#turnLeft").hide();
                        $("#turnRight").show();
                        $("#turnBoth").hide();
                        $("#turnOff").show();
                        break;
                    case 8:
                        $("#turnLeft").hide();
                        $("#turnRight").hide();
                        $("#turnBoth").show();
                        $("#turnOff").show();
                        break;
                    case 9:
                        $("#turnLeft").hide();
                        $("#turnRight").hide();
                        $("#turnBoth").hide();
                        $("#turnOff").show();
                        break;
                    case 10:
                        $("#seatbelt-off").show();
                        $("#seatbelt-on").show();
                        break;
                    case 11:
                        $("#seatbelt-off").hide();
                        $("#seatbelt-on").show();
                        break;
                    default:
                        $("#Green").hide();
                        $("#Yellow").hide();
                        $("#Red").hide();
                        $("#lightsOn").hide();
                        $("#lightsOff").hide();
                        $("#turnLeft").hide();
                        $("#turnRight").hide();
                        $("#turnBoth").hide();
                        $("#turnOff").hide();
                        $("#seatbelt-off").hide();
                        $("#seatbelt-on").hide();
                }
            }
        });
    };
});
