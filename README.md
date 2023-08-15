# <img src="./addons/collapsible_container/collapsible_elements/collapsible_container.svg" alt="drawing" width="25" style="padding-top: 20px;"/> CollapsibleContainer

<p align="center">
  <img src="https://github.com/ArshvirGoraya/Godot-Collapsible-Container/blob/4c06a8b8fbfd5e76a3a326910aea83fd19c517b0/.github/images/CollapsibleContainer_OpeningClosing.gif" alt="OpeningClosing in Game gif" />
</p>

## A Godot plugin node capable of expanding and collapsing.

A custom node for the Godot Game Engine that can help with many of your expanding/collapsing UI needs. It was initially made to mimic an [accordion UI](https://en.wikipedia.org/wiki/Accordion_(GUI)) element.

  <img align="right" width="30%" src="https://github.com/ArshvirGoraya/Godot-Collapsible-Container/blob/4c06a8b8fbfd5e76a3a326910aea83fd19c517b0/.github/images/EditorPreview.gif" alt="OpeningClosing in Editor gif" />
  
  ## Table of contents
* [Node Information](#node-information)
* [Tutorial video](#basic-tutorial-video)
* [Installation](#installation)
* [Contribute](#contribute)
* [Donate](#donate)
<!-- * [Known Issues](#known-issues) -->

## Node Information
* The node's folding and unfolding can be previewed directly in the editor.
* Any Control nodes childed to the node will be hidden when it folds and be revealed when it unfolds. This is optional.
* The size it expands to or collapses to can be changed to whatever you need. Optionally, it's 'open size' can be set to match a Control node's size; this Control node is generally set to the child node so that the CollapsibleContainer can open exactly to the size of the child to reveal it fully.
* The node can expand or collapse instantly, or be tweened towards the open/close size values. You can use any tween transition type and ease type of your choice.
* The direction (e.g., top-left, bottom-right, etc.) the node opens/closes towards can be changed.
* The dimension (i.e., width, height, or both) the node opens/closes can be changed.
* This node has comprehensive documentation. Just like with built-in nodes, you can utilize the documentation from within the Godot editor to quickly find and understand relevant functions.

## Basic Tutorial Video

Tutorial video going over the basics of the CollapsibleContainer node: https://youtu.be/o2qTSv0QmKA

## Installation

You can install the plugin from within Godot's AssetLib tab! Remember to enable it in Project Settings!

Official Godot guide to installing plugins: https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html

Video guide to install a release from GitHub: https://youtu.be/JRsGAgpPV8U
 
<details close>
  <summary><h4>Written Step-By-Step Guide to Install a Release from GitHub</h4></summary>
  
  1. In the [releases section](https://github.com/ArshvirGoraya/Godot-Collapsible-Container/releases), find the release which corresponds with your Godot version. If a Godot version is not listed, this plugin likely does not work in that Godot version.
  2. Download the .zip file from the release which corresponds with your Godot version.
  3. Open your Godot project.
  4. Create an "addons" folder if it does not already exist in your project's "res://" folder.
  5. Unzip downloaded zip file into that addons folder.
  6. Enable the plugin: Projects -> Project Settings -> Plugins -> Click enable on the CollapsibleContainer plugin.
  7. Done! You can now add the CollapsibleContainer node into your scene tree.
</details>

## Contribute
**Bug/Feedback**: Submit an issue using the issues tab after ensuring that it won't be a duplicate.

**Pull requests**: 
* The main tool script (and even the example projects) are all documented. This includes every function. For complicated functions, this may even include every line in that function. Hopefully this makes it easier to understand and contribute to the project.
* Submitting a pull request: you should file an issue first that your PR will resolve (if such an issue doesn't already exist). Then, reference what issue(s) your PR resolves in the PR. Your code must be documented.

<!---
## Known Issues

None... for now, but just released and hasn't been extensively tested. 
--->

## Donate
<a href='https://ko-fi.com/Z8Z6NP272' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi2.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
