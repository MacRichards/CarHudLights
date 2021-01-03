$(function () {
    window.onload = (e) => {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if (item !== undefined && item.type === false) {
                switch (item.kind) {
                    case 1:
                        $("#greenEngineLight").show();
                        $("#yellowEngineLight").hide();
                        $("#redEngineLight").hide();
                        break;
                    case 2:
                        $("#greenEngineLight").hide();
                        $("#yellowEngineLight").show();
                        $("#redEngineLight").hide();
                        break;
                    case 3:
                        $("#greenEngineLight").hide();
                        $("#yellowEngineLight").hide();
                        $("#redEngineLight").show();
                        break;
                    case 4:
                        $("#headLightsOn").show();
                        $("#headLightsOff").hide();
                        break;
                    case 5:
                        $("#headLightsOn").hide();
                        $("#headLightsOff").show();
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
                        $("#seatbeltOff").show();
                        $("#seatbeltOn").show();
                        break;
                    case 11:
                        $("#seatbeltOff").hide();
                        $("#seatbeltOn").show();
                        break;
                    case 12:
                        $("#greenEngineLight").hide();
                        $("#yellowEngineLight").hide();
                        $("#redEngineLight").hide();
                        $("#headLightsOn").hide();
                        $("#headLightsOff").hide();
                        $("#turnLeft").hide();
                        $("#turnRight").hide();
                        $("#turnBoth").hide();
                        $("#turnOff").hide();
                    default:
                        $("#greenEngineLight").hide();
                        $("#yellowEngineLight").hide();
                        $("#redEngineLight").hide();
                        $("#headLightsOn").hide();
                        $("#headLightsOff").hide();
                        $("#turnLeft").hide();
                        $("#turnRight").hide();
                        $("#turnBoth").hide();
                        $("#turnOff").hide();
                        $("#seatbeltOff").hide();
                        $("#seatbeltOn").hide();
                }
            }
        });
    };
});
