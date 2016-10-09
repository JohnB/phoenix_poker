# Phoenix Poker
[![Build Status][travis-img]][travis] [![License][license-img]][license]

[travis-img]: https://travis-ci.org/johnb/phoenix_poker.png?branch=master
[travis]: https://travis-ci.org/johnb/phoenix_poker
[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg
[license]: http://opensource.org/licenses/MIT

## Intended Database Tables

* Player: one who plays poker (nickname and email - both unique)
* Poker Night: the record of one night's game (date, buy-in, AttendeeResults)
* AttendeeResult: player_id, game_night_id, chips, rounding_method, result_in_cents 
* InvitedPlayers

## License

Please see [LICENSE](https://github.com/johnb/phoenix_poker/blob/master/LICENSE) for licensing details.
