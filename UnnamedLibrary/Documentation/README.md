# UnnamedDocumentation

- Any function starting with ":void" is a Library:Function operator
- Any function that has **AUTORAN** above it, no need to use it because it's ran automatically to make library run.
### UnnamedLibrary
```cpp
void GetPlayersByToken(<Token> string) >> { Instance }
```
Returns a table of all players from string.

```cpp
void GetPlayerByToken(<Token> string) >> Instance
```
Returns a single player from a string.

**AUTORAN**
```cpp
void CheckExploitSupport() >> boolean
```
Checks exploit support.

```cpp
void FindFunction(<Name> string) >> function
```
Finds a function through all function from the garbage collector (excluding exploit functions)

```cpp
void ConvertToAsset(<String> string) >> any
```
Converts RBXASSET or URL to an asset to be used. Pairs with [LoadCustomAsset, LoadCustomInstance]

```cpp
void LoadCustomAsset(<String> string) >> any
```
Loads a custom asset off RBXASSET or URL (uses ConvertToAsset to load [SOME GITHUB LINKS BROKE])

```cpp
void LoadCustomInstance(<String> string) >> Instance
```
Loads a custom instance off RBXASSET or URL (uses ConvertAdded to load [SOMEGITHUB LINKS BROKE])

```cpp
void GetRoot(<Model> Model | Player) >> Instance
```
Gets a root part of a player (If PrimaryPart is nil will go through every possible GOOD root part required)

```cpp
void SendChat(<Message> string, <To> string) >> nil
```
Forces you to send a chat in Default Roblox Chat

```cpp
:void FireTouch(<Part> Instance, <Reverse> boolean) >> nil
```
Fires a touch transmitter / interest.
> Reverse; Incase the part is touchable but requires a touchinterest from the PrimaryPart of the player and not the part (Defaults to False)

```cpp
:void FireFunction(<FunctionName> string) >> function
```
Fires a function and gives it arguments off name with up values.
```lua
UnnamedLibrary:FireFunction('Printarguments')(5, 2) -- Runs the Printarguments function and passed "5, 2" as the arguments.
```

```cpp
void CheckNumber(<Type> string, <Number> number) >> boolean
```
Checks if number is type
> Type; Float | Integer

```cpp
void Replace(<String> string, <Replacement> string, <ReplaceTo> string) >> string
```
Alternative to :gsub, due to the fact :gsub can't replace all characters without a guaranteed error because of REGEX errors.
```lua
print(UnnamedLibrary.Replace("Hellx Wxrld", "x", "o")) -- Prints "Hello World"
```

```cpp
void Directory(<Module> table) >> { any: any }
```
Imagine it as the python "dir" function.

#### Create SubLibrary
```cpp
void Create(<InstanceType> string, <Parent> Instance, <Properties> table) >> class
```
Creates an Instance with set properties

```cpp
void Create:SetName(<Name> string) >> nil
void Create:SetCFrame(<CFrame> CFrame) >> nil
void Create:SetColor(<Color> Color3 | BrickColor) >> nil
void Create:SetPropertyData(<Data> table, <Lerp> float, <TweenData> table) >> nil
                                          Optional      Optional
void Create:SetPosition(<Position> Vector3 | UDim2) >> nil
```

```cpp
void GetNil(<NilName> string, <NilClass> string, <Properties> tabke) >> nil (Instance)
```
Gets a nil instance by properties.

```cpp
:void FireEvent(<EventName> string, <...> any) >> nil
```
Fires an event (Remotes and Bindables)

```cpp
void HasProperty(<Object> any, <Property> string) >> boolean
```
Checks if Object has a property or not

```cpp
:void WaitForChildOfClass(<Parent> Instance, <Name> string, <Type> string, <WaitFor> string)
```
Waits for a child of a certain instance type (Called by :IsA)

```cpp
:void FindByProperty(<Properties> table, <Parent> Instance, <Type> string) >> { Instance }
```
Finds all instances in a selected parent by properties

```cpp
void GetCharacter(<Player> Player | string | Model) >> Model
```
Gets a players character.

```cpp
void Notify(<Title> string, <Text> string, <Duration> number) >> nil
```
Notifies player
```lua
/* Default Notification */
UnnamedLibrary.Notify("Hello", "From me", 2)
/* Custom Notification */
UnnamedLibrary.CustomNotification = Parent.NotificationFrame -- NAME MUST BE "NotificationFrame" AND MUST BE A "Frame"
UnnamedLibrary.Notify("Hello", "From me", 2)
-- TITLE WILL CENTER TO TOP; Title ZIndex is 99
-- DESCRIPTION WILL CENTER TO MIDDLE; Description ZIndex is 99
```
```cpp
void ScaleToOffset(<ScaledUdim> UDim2) >> UDim2
```
Converts **UDim2.fromScale** to **UDim2.fromOffset**

```cpp
void OffsetToScale(<OffsetUdim> UDim2) >> UDim2
```
Converts **UDim2.fromOffset** to **UDim2.fromScale**

```cpp
void GetIndexValue(<Table> table, <Value> string) >> number
```
Returns the index of a value in a table,

```cpp
void SetCursor(<Cursor> string, <Size> UDim2) >> nil
```
Changes the cursor type (Disable it by setting no arguments to SetCursor)

### Player SubLibrary
```cpp
void Player.SetSpeed(<Speed> number) >> nil
```
Changes the players walk speed

```cpp
void Player.SetJump(<Power> number) >> nil
```
Changes the players jump power

```cpp
void Player.Kill(<BreakJoints> boolean) >> nil
```

### Conversions SubLibrary
```cpp
void COnversions.CustomEncodingAlgorithm(<AlgorithmName> string, <Table> table) >> { function, function, table }
```
Custom string encode/decode algorithm like Base64, Base32, Cypher, etc.

### Math SubLibrary
```cpp
void Math.rval(<Number> number, <ReturnValue> any) >> number | boolean
```
If number argument is less-than or equal to 0 than it'll return 0/false, if its greater than 0 then it'll return the ReturnValue argument

### Random SubLibrary
```cpp
void Random.String(<Amount> number, <IncluddeCaps> boolean) >> string
```
Makes a random string with the length of the Amount argument and has caps if IncludeCaps argument is true.
E.X: #rFSi(*

```cpp
void Random.Int(<Min> number, <max> number) >> number
```
Returns a random int. (No decimals)


```cpp
void Random.Float(<Min> number, <max> number) >> number
```
Returns a random float. (Decimals)
