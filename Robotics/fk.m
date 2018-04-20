function coords = fk(dh, num_links)

    % Extract variables
    a = dh(:, 1);
    al = dh(:, 2);
    d = dh(:, 3);
    th = dh(:, 4);

    % Set A matrices
    A = zeros(4, 4, num_links);

    for i = 1:num_links
        A(:, :, i) = [cosd(th(i)), -sind(th(i))*cosd(al(i)), sind(th(i))*sind(al(i)), a(i)*cosd(th(i));
                    sind(th(i)), cosd(th(i))*cosd(al(i)), -cosd(th(i))*sind(al(i)), a(i)*sind(th(i));
                    0, sind(al(i)), cosd(al(i)), d(i);
                    0, 0, 0, 1];
    end

    % Multiply A matrices
    T = A(:,:,1);
    for i = 2:num_links
        T = T*A(:, :, i);
    end

    % Calculate Coordinates
    coords = [T(1, 4), T(2, 4), T(3, 4)];

end