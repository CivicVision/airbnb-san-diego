# AirBnB in San Diego

In 2015/2016 there was a big controversy around AirBnB not only in San Diego but all around the world.  
But since I'm very interesting in San Diego politics I thought it might be a neat idea to create a small tool to check the municipal code if an AirBnB would be allowed in the address the user provides.  

I had more plans for this but it never got any traction, so I let it slide.  

The tool is based on the Zoning Section of the [Municipal Code]("https://www.sandiego.gov/city-clerk/officialdocs/municipal-code/chapter-13") and on Section 141.0603 of the Municipal Code in 2016.

## Development

This repo uses middleman a static site generator built with ruby.

### Installation
Install required libraries (middleman via bundler) javascript tools via npm

```
bundle install
npm install
```

### Run

```
middleman
```

Open `localhost:4567` and you see the site.
