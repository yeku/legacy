<img align="left" src="./github-assets/Logos/LegacyBackground.png" alt="Legacy" height="150" />

<a href="https://raw.githubusercontent.com/yeku/legacy/refs/heads/main/Source.luau"> <img align="right" src="./github-assets/Buttons/Source.svg" alt="Source" height="150" /> </a>

<!-- <img align="right" src="./github-assets/Gaps/Gap.svg" alt="" width="1" height="200" /> -->

<a href="https://github.com/yeku/legacy#loadstring"> <img align="right" src="./github-assets/Buttons/Loadstring.svg" alt="Loadstring" height="150" /> </a>

<img src="./github-assets/Gaps/ClearFloat.svg" alt="" />

<p align="center">
  <a href="https://github.com/yeku/legacy/stargazers">
    <img src="https://img.shields.io/github/stars/yeku/legacy?style=social" alt="GitHub stars">
  </a>
  <a href="https://github.com/yeku/legacy/commits">
    <img src="https://img.shields.io/github/last-commit/yeku/legacy?style=social&label=last%20update" alt="Last update">
  </a>
  <a href="https://github.com/yeku/legacy/issues">
    <img src="https://img.shields.io/github/issues/yeku/legacy?style=social" alt="Open issues">
  </a>
</p>

# Legacy
A project that returns back the legacy CoreGui styles (from 2012 all the way to 2016)

Legacy replaces the modern CoreGui with the older styles, without breaking anything

## Features
- Open source
- Optional classic graphics
- Username nametags (instead of display name)
- Classic safe chat menu
- Classic developer console
- Classic bubble chat

## Loadstring
```lua
getgenv().LegacySettings = ({
    Year = 2016, -- only 2012 to 2016 allowed (if unavailable, it will be set to 2016 by default)
    OldGraphics = true, -- changes graphics to be more like the 2016 graphics
    HideDisplayName = true, -- changes other users nametags to show their username instead of display name
    SafeChat = false, -- adds the safechat button, only works on 2012, 2013 and 2014
    OldConsole = false, -- adds the old developer console back
    OldBubbleChat = false, -- makes the bubble chat style like the 2016 one
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/yeku/legacy/refs/heads/main/Source.luau"))()
```

# Credits
Most of the source code was originally created by ROBLOX over the years

Full credit goes to ROBLOX and its original developers

# Showcase
<img align="left" src="./github-assets/Years/2016.png" alt="2016" height="350" />
<img align="left" src="./github-assets/Years/2015.png" alt="2015" height="350" />
<img align="left" src="./github-assets/Years/2014.png" alt="2014" height="350" />
<img align="left" src="./github-assets/Years/2013.png" alt="2013" height="350" />
<img align="left" src="./github-assets/Years/2012.png" alt="2012" height="350" />
