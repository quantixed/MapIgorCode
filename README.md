# MapIgorCode

Create a map of IgorPro functions in procedure files

--

**Aim** make a map of all the functions in Igor procedure files to enable the location of appropriate code for other projects.

This is a solution for macOS. It uses shell commands, Igor and lastly d3.js to display the map. It uses work by other people that I have appropiated.

- In the terminal, cd to the directory containing the `*.ipf` files you want to map. Execute:

```shell
grep "^[ \t]*Function" *.ipf | grep -oE '[ \t]+[A-Za-z_0-9]+\(' | tr -d " " | tr -d "(" > output
for i in `cat output`; do grep -ie "$i" *.ipf | grep -w "Function" >> funcfile.txt ; done
sed -i -e 's/.ipf:Function /  /g' funcfile.txt
```

- Use `JSONFromFuncFile.ipf`, point Igor to `funcfile.txt`
- The resulting file, `funcMap.json` can be used with `display.html` to see the map.

![Working example of Igor code map](https://github.com/quantixed/MapIgorCode/blob/master/output.gif)

** Notes

1. The tab character is used in `sed`. Use ctrl+v and tab to get it if copy paste or .sh does not work.
2. The d3.js example is from [here](https://gist.github.com/mbostock/4339083) and [working example](https://bl.ocks.org/mbostock/4339083).