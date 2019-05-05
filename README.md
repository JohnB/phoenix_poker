# Phoenix Poker

The original phoenix poker app was written _just before_ Phoenix
changed their directory structure. I never bothered to upgrede,
which saved me time, but now it will be a lot of work to add LiveView.
Luckily (or, the final straw), the app stopped compiling for some reason.
Yeah, I could figure it out but it might actually _be_ better to 
rebuild from the ground up. 

## Roadmap for the Rebuild

* [x] Start a branch so we don't make anything worse.
* [x] Replace entire dir with fresh Phoenix app.
* [ ] Rebuild previous migrations to get the exact same data model.
* [ ] Re-add EuberAuth (google, twitter, github).
* [ ] Consider limiting to existing users.
* [ ] Restore games CRUD.
* [ ] Restore game index.
* [ ] Restore player selection.
* [ ] Consider LiveView for the checkout page.
* [ ] Re-add heroku integration.
* [ ] Consider delaying the push to heroku if we're close to the June 7th Poken Night.
* [ ] Can we even re-deploy the existing master branch if we're having trouble compiling master? 
* [ ] Merge back to master
* [ ] Deploy to heroku

## Data Model

* Player: one who plays poker (nickname and email - both unique)
* GameNight: the record of one night's game (date, buy-in, AttendeeResults)
* AttendeeResult: player_id, game_night_id, chips, rounding_method, result_in_cents 
* InvitedPlayers

## License

Please see [LICENSE](https://github.com/johnb/phoenix_poker/blob/master/LICENSE) for licensing details.
