<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="./static/icon.png" alt="Project logo" ></a>
 <br>

</p>

<h3 align="center">Cloud Storage Tutorial</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/da-huin/cloud-storeage-tutorial.svg)](https://github.com/da-huin/cloud-storeage-tutorial/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/da-huin/cloud-storeage-tutorial.svg)](https://github.com/da-huin/cloud-storeage-tutorial/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> 
    <br> Tutorial of Storage in GCP.
</p>

## 📝 Table of Contents

- [Getting Started](#getting_started)
- [Acknowledgments](#acknowledgement)

## 🏁 Getting Started <a name = "getting_started"></a>

This document explains how to store data in GCP Storage and how to download data from machine learning code.

1. **Select `Storage Button` in GCP Console Navigation.**

    GCP Console URL: https://console.cloud.google.com/home/dashboard

    <img src="./static/20200818_025336.png" width="200">

    * `Bigtable` is a fully managed, wide-column NoSQL database.
    * `Datastore / Firebase` is used for creating and managing cloud document servers. 
    * `Cloud Spanner` is a managed and scalable relational database.
    * `Memorystore` is redis.

1. **Create Bucket**

    Bucket is containers for data.

    1. Click `CREATE BUCKET` button.

        <img src="./static/20200818_030112.png">

    1. Fill fields and click `CREATE` button.

        <img src="./static/20200818_030347.png">

    1. Click bucket name for directly upload file.

        <img src="./static/20200818_030721.png">

    1. Click `UPLOAD FOLDER` button to upload your data. 

        <img src="./static/20200818_031051.png">

        <img src="./static/20200818_032500.png">

1. **Open jupyterlab in [GCP AI Platform Notebooks](https://github.com/da-huin/ai-notebook-tutorial).**
    
1. **We will download the stored data from the GCP repository. Prepare your code.**

    <img src="./static/20200818_035855.png">

1. **Refer to the code below to load datas.**

    ```python
    import os
    from google.cloud import storage

    # get handler of GCP storage.
    client = storage.Client()
    print("Client created using default project: {}".format(client.project))

    # fill your bucket name.
    bucket_name = "sample-bucket-818"
    # fill your directory path.
    directory_path = "UCIHARDataset"

    # This function downloads a directory from GCP Storage.
    def download_directory(bucket_name, directory_path):
        
        # get bucket handler.
        bucket = client.get_bucket(bucket_name)
        
        # get filenames starting with `directory_path`
        blobs = bucket.list_blobs(prefix=directory_path)
        print(f"[{bucket.name}] {directory_path}:")
        
        for item in blobs:
            
            source_blob_name = item.name
            destination_file_name = "./" + item.name
            
            if os.path.isfile(destination_file_name):
                print(f"\t{destination_file_name} already exists.")
                continue

            os.makedirs(os.path.dirname(destination_file_name), exist_ok=True)
            
            # get blob handler.
            blob = bucket.blob(source_blob_name)
            
            # download to our jupyter.
            blob.download_to_filename(destination_file_name)
            
            print(f"\t{source_blob_name} >>> {destination_file_name}.")
        
        print("download is complate!")

    download_directory(bucket_name, directory_path)
    ```

    * result:

        ```
        Client created using default project: your-project-name

        ...

        download is complate!
        ```

1. **Run your code.**

    ```
    ...

    Training iter #1500:   Batch Loss = 3.590366, Accuracy = 0.1586666703224182
    PERFORMANCE ON TEST SET: Batch Loss = 2.7740159034729004, Accuracy = 0.22056327760219574    

    ...
    ```

1. **(Reference) If you want save local file to a bucket as code, use the code below.**

    ```python
    blob_name = "your_destination_filename"
    blob = bucket.blob(blob_name)

    source_file_name = "your_source_file_name"
    blob.upload_from_filename(source_file_name)

    print("File uploaded to {}.".format(bucket.name))
    ```

1. **Tutorial is over 😀**