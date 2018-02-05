# OOP Talks: Why You Should Stop Implementing Functions in Classes

In this article we will discuss some problems of class-based OOP and why you should move to interface-based OOP.

When I was in my first year undergrad OOP class, we were told that OOP is a brilliant way to model everything in life, that everything is an object, and we should write methods associative to the object in its class. I went on becoming a teaching assistant and the university and told my students the same thing. It is not until a few years later I realize I was lied to, and so were my students. Classes are not a decent way to model things for many reasons. It is wasteful in resources when child classes have to a chain of parent properties that are not always necessary. Its style of polymorphism creates complications such as the diamond problem, unsafe up and down casting, when not bringing any special benefits to the table. (Remember, there are many other languages that are living happily using other methods of polymorphism.) It gives too much freedom to code maintainers, and leads them to extending a class in unintended way and breaking the code... many experienced programmers, like you, know the frustration. 

This suffering ends the moment we stop writing functions in classes, and I'm not suggesting we should all go back to stone age and write in C, but instead, most methods you wrote in classes should actually be in interfaces (or equivalence in any language). Higher readability and reusability can be achieved this way. Before my explanation of this, let me first clarify what I mean by OOP in this article. By OOP I mean C++ or Java-like languages, where you have features such as class, interface (or abstract class), virtual methods (or anyway to override base class methods). We should stop advertising OOP as a modeling tool. It is rather a way to organize your code, grouping relative data in different places. A program is really just data plus procedures. So you should put data in classes, procedures in interfaces.

## "If it ain't broke, don't fix it"

We all once lived happily with one technology until something better is developed. There is nothing wrong with Nokia, but Apple out-classed Nokia so Nokia went "broke". Similarly, our goal is not just make a programming language work, but work better. So let us not be narrow-minded OOP worshipers and take a look at some realy problematic designs choices of OOP.

## Dynamic Polymorphism Is Broken

Recall that in OOP dynamic polymorphism means the program automatically figures out the type of pointers during runtime. For example, if a function takes a base class as a parameter, and you pass a child class into the function, then compile generates code so that the meaning of `this` is figured out during runtime. This unfortunately results in counter-intuitive bahaviors in some cases, leaving bugs in your code that are exremely hard to spot.

Here's a pesduo-code example: suppose you have a base class `A` and a child `A_child`:

```C++
class A {};                 // parent
class A_child: public A {}; // child
```

And you want to overload a method named `f` in some other class `B`, where the first `f` takes `A`, and the other `f` takes `A_child`.

```C++
class B {
    public:
    void f(A* a) {
      cout << "called f(A)";
    }     
    void f(A_child* a) {
      cout << "called f(A_child)";
    } 
};
```

Say you have a pointer `ptr` of type `A`, which is actually pointing to `A_child`. This is a classical situation where you expect dynamic dispath to happen. Now think what happens if you call `f(ptr)` before proceeding.

```C++
int main() {
    A* ptr = new A_child();
    (new B())->f(ptr); 
}
```

Do you believe if I tell you the code prints out `"called f(A)"`? 

The first time I saw this in class I jumped from my seat. Wow! What the actual fuck? This is like a trap in a programming code waiting for its prey to step into. Even after knowing the correct answer it is still hard to comprehend why this is the case. So what is to blame here? The reason is we have been tricked into thinking this is a case of dynamic dispath, when it is really about resolving overloaded methods. The resolution of overloaded methods happens at compile time. So the compiler looks at the `A* ptr = new A_child()` and goes, "oh! `ptr` is an `A*` type, so I'm going to call the `f(A)` version of `class B`". The compiler makes a counter-intuitive decision to the programmer, and there's really no way to fix it unless we can get rid of method overloading or dynmaic dispath all together, because the compiler's choice is by the design of the language. 

Just imagine you're maintaining a large amount of code that contains this bug, and after wasting hours on debugging you finally figured out this misconcept. Then it's time to ask, "how do I fix it?" Then you bring out your favorite OOP design pattern book and read that you should apply "double dispath" pattern here. You scratch your head and ask, why does it have to be so perplexed? Dear! This is what OOP programmers do! We take a very simple take, make it difficult so it makes us feel smarter. "But... A true OOP programmer would know this kind of stuff and not make such mistake!" You might argue, and I totally agree with that. However, why would I waste my time learning, dodging and debuging these language shortcomings when I can be solving more important problems or writting more apps? Why would I have to work around a programming language when the programming language should serve me instead? A good programming language should be intuitive and expressive, and OOP fails to be so.

## Dynamic Polymorphism Is Out-classed by Interface




## Children are out of control

Got a parenting problem? One thing that OOP promises, abstraction, is fragile since a base class imposes no restriction on what children must override, and what rule they must follow. It is up to the children to decide what to do. This freedom in fact does more harm than good. Just ask yourself how many times your project started with a clean base code, then as the development progresses the code slowly grows and becomes more complex, and with new programmers join the team, experienced programmers who started the base code leaves the team, the project becomes harder and harder to manage, and every maintenance seems to fix something but breaks something else? This happens because while in OOP decision of implementation can be deferred to children but there is no way for a base class to impose a rule on how a child should behave or follow some properties. This burden of making sure children's implementation follows the original design is given to a programmer, who may be inexperienced with the parent classes and may end up overriding a method in unintended ways.

Here's an example of a base class

