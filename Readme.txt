
- A list of the programming patterns used, with a brief description of how you used them and why.

- Factory patterns
    I used factor patterns to create each card so they would have the same poperties while being
    able to have different values for things like the value and if they are grabbale or not. This also
    made it easy to add new properties or change aspects of all the cards at once. 

- State patterns
    I used state patterns to track card states between idle, mouse over, and grabbed. This made it easy
    to make the cards or the grabber react differently depending on the state of the card. It also differentiates
    how the cards react different when they are simply hovered over verses actaully grabbed. 

- Singleton patterns
    I used this for the grabber so I could make a singular grabber that would have different properties
    and values I could call and manipulate to make the game function. It made it easy to process the main action of the
    game as it is easier to pass the selected card into the grabber then iterate through all cards to find which one the
    grabber needs to affect. 

- Observer/Listner patterns
    I used these patterns in order to track mouse movement and which cards had the mouse over it at what time. 
    It helped by allowing each card to act and process the input detection independently. This also allows for features
    like the shadow and any other features I may add. 

- Iterator patterns
    I used these to iterate over the differnt tables of cards I have whether its loading sprites, placing cards, shuffling
    them, or drawing from the stack. This made it easy to get all the cards in a couple lines as well as make the effect or
    action uniform. 


- A postmortem on what you did well and what you would do differently if you were to do this project over again (maybe some programming patterns that might have been a better fit?).
    I think I have a lot of code that could be simplified as well as working with a sprite sheet rather than individual pngs for my cards. 
    I think a good amount of my logic is efficient like the grabber which was fun to build off of what we got in lecture. Also I liked having
    seperate tables for the stack of cards and the cards on the board as I wanted them to behave differently and while that meant having
    to switch cards between tables when they were moves, I think I managed to do it in a rather efficient way. I think if I were to redo
    this project I would sit down before hand and write out all my logic and what I need to implement instead of building as I went so that
    I could possibly cut down on properties I'm tracking or values I'm storing or just the amount of lines overall. 


- Sprites: https://opengameart.org/content/playing-cards-pack
- I didn’t make any of the assets in this project.

- I used the base solitare code we got from lecture as a base and built my code up from it!