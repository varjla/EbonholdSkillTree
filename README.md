# Ebonhold Skill Tree

Ebonhold Skill Tree is a lightweight World of Warcraft AddOn (for the 3.3.5a client) designed specifically for the Ebonhold server. It introduces a fast and accessible way to open the custom Skill Tree interface through a custom keybind and integrates seamlessly into the default UI tooltips.

## Features

- **Custom Keybind:** Maps `SHIFT+N` by default to open the Ebonhold Skill Tree.
![Custom Keybind Feature](https://imgur.com/oOg46kN)
- **Micro Button Tooltip Integration:** Seamlessly updates the game's Skill Tree micro button tooltip to display your currently bound shortcut in the native WoW gold text format (e.g., matching the style of `Game Menu (Escape)`).
- **Dynamic Bindings:** If you change the keybind in the game's default Key Bindings menu, the tooltip updates automatically without any hardcoded text values.
- **Localization Support:** Includes localized strings (and a chat notification on first load) for multiple languages out of the box (English, Spanish, French, German, Russian, Italian).

## Installation

1. Download the latest version of the AddOn.
2. Extract the `EbonholdSkillTree` folder.
3. Place the folder into your World of Warcraft `Interface\AddOns` directory:
   `<Your WoW Directory>\Interface\AddOns\EbonholdSkillTree`
4. Launch the game and ensure the AddOn is enabled in the character selection screen's "AddOns" button.

## Usage

Upon logging in, if no keybind is currently set, the AddOn will automatically map `SHIFT+N` to the Skill Tree action and notify you in the chat with a customized message.

You can change this keybind at any time:
1. Open the Game Menu (`ESC`).
2. Go to **Key Bindings**.
3. Scroll down to the **Ebonhold App** category.
4. Set a new key for **Toggle Skill Tree**.
5. Click **Okay**.

Enjoy the AddOn! Hover over the custom Skill Tree micro button to see your assigned keybind perfectly integrated.
