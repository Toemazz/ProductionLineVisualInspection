# ProductionLineVisualInspection

## Description
Image processing is often used in industrial applications. One of the most common uses for image processing is for automated visual inspection of a product before being packaged and shipped to the customer. Using these types of systems in production facilities aids the avoidance of situations where a faulty or sub-standard product is shipped to the customer.

For an example scenario, a Coca-Cola bottling plant production line was used to demonstate how image processing could be used for an automated visual inspection application. A set of images were provided, taken under near constant  lighting conditions in the factory. These set of images include both _good_ and _bad_ bottles which the bottling company expects you to use to detect certain faults as part of the filling, capping and labelling operations before the final packaging stage.

## Assumptions
The list of assumptions made at the start of the project:
- Constant lighting conditions
- Constant bottle positioning
- Only faults in centre bottle are required to be detected
- Faults on side bottles will be dealt with separately

## Faults
The list of possible faults which can occur for the center bottle:
1. Bottle Cap Missing
2. Bottle Deformed
3. Bottle Missing
4. Bottle Overfilled
5. Bottle Underfilled
6. Label Missing
7. Label Not Printed
8. Label Not Stright

## Results
Classification results for set of images for each individual fault:

__Fault Type__     | __# Images__ | __# Faults Detected__ | __Classification %__
------------------ | ------------ | --------------------- | --------------------
Bottle Cap Missing | 10           | 10                    | ___100%___
Bottle Deformed    | 10           | 9                     | ___90%___
Bottle Missing     | 11           | 11                    | ___100%___
Bottle Overfilled  | 10           | 10                    | ___100%___
Bottle Underfilled | 10           | 10                    | ___100%___
Label Missing      | 10           | 10                    | ___100%___
Label Not Printed  | 10           | 10                    | ___100%___
Label Not Stright  | 10           | 10                    | ___100%___
Multiple Faults    | 10           | 9                     | ___90%___

Classification results for set of all 141 images:

__Fault Type__     | __# Images__ | __# Faults Detected__ | __Classification %__
------------------ | ------------ | --------------------- | --------------------
All                | 141          | 139                   | ___98.58%___
