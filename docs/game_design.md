# EtherQuest — Game Design Document

## Overview

**EtherQuest** is a browser-based MMO Fantasy RPG where players explore dungeons, defeat monsters, and collect rare items. Unlike traditional online games, all in-game items are owned by players on the Ethereum blockchain — not by the game studio. Players keep their items even if the game shuts down, can freely trade them with other players, and can prove rarity at the contract level.

## Genre & Platform

- **Genre:** Fantasy MMO RPG with PvE dungeon crawling and PvP duels
- **Platform:** Browser-based (HTML5/WebGL) — no download required
- **Target audience:** Crypto-curious gamers aged 18-35 who play games like World of Warcraft, Diablo, or Path of Exile

## Core Gameplay Loop

1. Players create an adventurer character and connect their MetaMask wallet
2. They explore procedurally-generated dungeons solo or in parties
3. Defeating bosses drops loot (items minted as on-chain assets)
4. Players equip items to boost combat stats
5. Items can be traded peer-to-peer via the in-game marketplace
6. Rare items become valuable across the player economy

## Item System

### Categories

- **Weapons:** Swords, axes, staves, bows. Provide attack power.
- **Armor:** Helmets, shields, boots, chest plates. Provide defense power.
- **Potions:** Health, mana, strength buffs. Consumable.
- **Special:** Rings, scrolls, artifacts. Unique abilities.

### Rarity Tiers

| Tier | Color | Drop Rate | Source |
|------|-------|-----------|--------|
| Common | Gray | ~70% | Standard mob drops |
| Uncommon | Green | ~20% | Elite mobs |
| Rare | Blue | ~7% | Mini-bosses |
| Epic | Purple | ~2.5% | Dungeon bosses |
| Legendary | Orange | ~0.5% | Raid bosses & events |

### Stats per Item

- `attackPower` — adds to player's damage output
- `defensePower` — reduces incoming damage
- `price` — sale price in ETH (set by owner when listing)
- `rarity` — visual + drop rate
- `itemType` — category for inventory filtering

## Architecture: On-Chain vs Off-Chain

| Layer | What it does | Where it runs |
|-------|--------------|---------------|
| **On-chain** | Item ownership, trading, rarity verification | Ethereum (Sepolia testnet for demo, Polygon for production) |
| **Off-chain** | Combat, graphics, animation, story, real-time multiplayer | Game servers + browser client |

Combat happens off-chain because each attack would otherwise cost gas and take 15+ seconds to confirm. Item ownership and trades happen on-chain because that's where the trust matters.

## Sample Items (Currently Deployed)

| ID | Name | Type | Rarity | ATK | DEF | Price |
|----|------|------|--------|-----|-----|-------|
| 1 | Iron Sword | Weapon | Common | 10 | 0 | 0.01 ETH |
| 2 | Mithril Shield | Armor | Rare | 0 | 25 | 0.05 ETH |
| 3 | Sword of Frost | Weapon | Legendary | 100 | 15 | 0.20 ETH |

## Real-World Precedents

EtherQuest follows the model proven by:
- **Axie Infinity** — $1.3B+ in trading volume from blockchain pet battles
- **Gods Unchained** — Blockchain TCG with player-owned cards
- **Illuvium** — AAA-quality blockchain MMO

## Why Blockchain (the "Why?" answer)

Traditional games own your items. If the company shuts down, bans your account, or changes their policy, your items disappear. Players spend real money on assets they don't actually own. EtherQuest moves item ownership on-chain so:

1. Items survive game shutdowns
2. No central authority can revoke ownership
3. Trades are peer-to-peer with no platform fees
4. Item rarity is provably scarce (not just claimed)