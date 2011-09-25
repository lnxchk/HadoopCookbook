# Info for populating your hadoop/hadoop data bag item

The data bag for this cookbook is optional. If you choose to lock the version of the hadoop packages used in your 
environment, you can use the data bag to accomplish this. You can also just change the code in the recipes.

The current default version is "0.20" as of September 20, 2011.

1. Create a data bag: `knife create data bag hadoop`
2. I generally create my data bags as files, so I would create a file in the `data_bags/hadoop` directory called `hadoop.json`. You could also create the data bag using knife, see http://wiki.opscode.com/display/chef/Data+Bags for more info on data bags.
3. The `hadoop` item in the `hadoop` data bag contains one key and value pair, plus the id:
```
    {
      "id": "hadoop",
      "hadoop_version": "0.21"
    }
```
4. Upload the data bag: `knife data bag from file hadoop hadoop.json`

If you prefer your data bag item file to be directly in the data_bags directory, you'll need to change the recipes that access it.

