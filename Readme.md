# Cookie Click Game
A click game demo, made from godot 4 with Big.gd

![image](screenshot2.png)

Big.gd is a GodotBigNumberClass which use for very big number,
so I try it to make a click game such as cookies clicker

### Big.gd links:
- [BigNumGodot4](https://github.com/BrastenXBL/Godot4BigNumberClass) (https://github.com/BrastenXBL/Godot4BigNumberClass)

## To-Do
- [x] Cookie earn from click
- [x] Auto clicker for earn more cookies
- [x] Cookie effect drop when click
- [x] Super cookies button spawn in 7~15 random seconds
- [x] Every number change to Big class
- [ ] Achievements
- [ ] Balance of game
- [x] SaveLoad System (new)
- [x] Reset save button (new)
- [ ] The goal of game
## Tips of use Big.gd
When you want to make some value checking, becareful on calling class.

If you want to modify your number for value checking, try this. It wouldn't change on your base number.
``` 
var temp = Big.new(valueYouWantToRead) 
print(temp.plus(10).toString())
```
