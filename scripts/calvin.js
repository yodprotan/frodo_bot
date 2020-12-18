// Description:
//   Returns a random calvin and hobbes comic
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   `frodo random calvin` - returns a random calvin and hobbes comic
//

module.exports = (robot) => {
  robot.respond(/^random calvin$/i, (msg) => {
    url = "https://www.gocomics.com/calvinandhobbes/2020/12/12";
    // First comic was in 2007
    year = 2007 + Math.floor(Math.random() * 15);
    month = Math.floor(Math.random() * 13);
    // Sorry 30 and 31 :(
    day = Math.floor(Math.random() * 29);
    slash = "/";
    response = url.concat(
      year.toString(),
      slash,
      month.toString(),
      slash,
      day.toString()
    );
    msg.send(response);
  });
};
