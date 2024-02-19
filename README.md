Forge
===========

Forge is an intuitive yet powerful template engine for MATLAB.

About
-----

Forge is an intuitive yet powerful template engine crafted for generating dynamic content with MATLAB. It supports variables, comments, conditionals, and loops as fundamental elements for template creation. Additionally, Forge enables the nesting of templates for more modular dynamic rendering, alongside the capability to cache previously rendered templates to enhance rendering speed. This combination of simplicity and efficiency makes Forge an excellent option for projects of any size.

Examples
--------

See the [examples](/toolbox/examples) folder for more detailed examples.

### Basic Strings

Installing the toolbox will add Forge to your MATLAB path. Create an instance of this class as a renderer.

```matlab
% Create the renderer
renderer = Forge();

% Create a template string with variable 'name'
tmpl = "Hello, {name}!";

% Create a context that defines the template variables
ctx.name = "world";

% Render and display the output
greeting = renderer.render(tmpl, ctx);
disp(greeting);
```

We can reuse the template and render it with a different context to create a new greeting message.

```matlab
% Render and display with a different context
ctx.name = "friend";
greeting = renderer.render(tmpl, ctx);
disp(greeting);
```

### Loops and Conditionals

We can build on this example using loops and conditional statements to greet all names in a list.

```matlab
% Create the renderer
renderer = Forge();

% Create a template string to loop through 'names'.
% Use a conditional to ensure the grammar is correct if we are at the end of the list.
tmpl = "Hello {for name=names}{if name~=names(end)}{name}, {end}{if name==names(end)}and {name}.{end}{end}";

% Create a context with a list of names
ctx.names = ["Jim", "Jeff", "Jane"];

% Render and display the output
greeting = renderer.render(tmpl, ctx);
disp(greeting);
```

### HTML Example
This example is similar to the Basic Strings example above but shows how Forge can be used to render HTML. First create a file called `post.mtl` with the defined template.

```html
<!-- post.mtl -->
<div>
    <h2 style="margin-top: 0; color: #333;">{title}</h2>
    <p style="color: #666; font-size: 14px;">
        Posted on <time>{date}</time> by <span style="font-weight: bold;">{author}</span>
    </p>
    <p style="color: #555;">{summary}</p>
    <a href="{ref}" style="color: blue; text-decoration: none;">Read more &rarr;</a>
</div>
```

Next we load the file into MATLAB using `fileread` and render it.

```matlab
% Create the renderer
renderer = Forge();

% Load template to variable
blogPostTmpl = fileread("post.mtl");

% Define template variables in the context
ctx.title = "Getting started with Forge";
ctx.date = string(datetime);
ctx.author = "David";
ctx.summary = "Forge is a simple yet powerful template engine!";
ctx.ref = "/getting-started";

% Render and save the output to a .html file
post = renderer.render(blogPostTmpl, ctx);
writelines(post, "post.html");
```

Usage
-----

### Tags

Tags are any substring wrapped in curly braces, for example, `{myvar}`. The words `if`, `elseif`, `else`, `for`, and `end` are reserved  keywords and should not be used for variable names. To prevent a tag  from being rendered, prepend it with a backslash. The `>` character  is used for nesting templates. Tags should contain valid MATLAB  statements using variables in the context.

Example: `"{myvar}"`

### Comments

Comments in Forge are denoted by `{%` and `%}`.  Text within these markers will not be rendered, allowing template  authors to include notes or explanations within their templates.  Comments can span multiple lines and include spaces, newlines, and other tags without affecting the output.

Example: `"{% This won't show up in the rendered string %}"`

### Conditionals

Conditional logic is supported using the `if`, `elseif`, and `else`  keywords within tags. This feature enables the template to render or  omit specific substrings based on given conditions. Every conditional  block must be concluded with an `end` tag.

Example: `"{if isempty(posts)}There are no posts!{else}There are posts!{end}"`

### Loops
Loops are constructed with the `for` keyword, following MATLAB's loop syntax, and must also be concluded with an end tag. This functionality allows for the iteration over arrays within the template. Every loop must be closed with an `end` tag.

Example: `"{for name=names}Hi {name}!{end}"`

### Nesting

Nested templates are indicated by tags enclosed with `{>` and `}`.  These allow for the inclusion of other template strings that can utilize any context variables provided by the parent template, facilitating  modular template design and reuse. All subtemplates have access to variables in the context of the parent template.

Example: `"{>subtemplate}"`

Build and Test
--------------

Forge uses the [MATLAB Build Tool](https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html) to lint, test, and package. To run all tests and package the toolbox, run `buildtool` from the repository root. Run `buildtool -tasks` to see the list of all available tasks.

Acknowledgments
---------------
Forge has looked to these projects as a source of inspriation:
* http://github.com/janl/mustache.js
* https://github.com/gsf/whiskers.js
