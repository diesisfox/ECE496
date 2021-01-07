const theme_style = getComputedStyle(document.body)
const light_blue_color = getHexFromRGB(theme_style.getPropertyValue("--button-hover-border"))

function getHexFromRGB(rgb_string){
    // get R,G,B
    var three_integers = rgb_string.split("(")[1].split(")")[0]

    // convert base 10 to base 16
    var hex_string = three_integers.split(",").map(function(x){
        x = parseInt(x).toString(16);
        return (x.length==1) ? "0"+x : x; // add a 0 if there is only one number
    })

    return "#"+hex_string.join("")
}


module.exports = {
    theme_style,
    light_blue_color,
    getHexFromRGB,
}