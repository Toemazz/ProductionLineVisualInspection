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

Fault Type         | # Images | # Faults Detected | Classification %
------------------ | -------- | ----------------- | ----------------
Bottle Cap Missing | 10       | 10                | 100%
Bottle Deformed    | 10       | 9                 | 90%
Bottle Missing     | 11       | 11                | 100%
Bottle Overfilled  | 10       | 10                | 100%
Bottle Underfilled | 10       | 10                | 100%
Label Missing      | 10       | 10                | 100%
Label Not Printed  | 10       | 10                | 100%
Label Not Stright  | 10       | 10                | 100%
Multiple Faults    | 10       | 9                 | 90%

Classification results for set of all 141 images:

Fault Type         | # Images | # Faults Detected | Classification %
------------------ | -------- | ----------------- | ----------------
All                | 141      | 139               | 98.58%
